class Request < ApplicationRecord
  before_save :set_stathist, :handle_est_hours
  has_paper_trail
  validates :name, presence: true # Make sure the owner's name is present.
  validates :title, presence: true
  validates_with OngoingValidator
  validates_presence_of :esthours, :if => lambda { self.status == "Ongoing" }
  validates_presence_of :tothours, :if => lambda { self.status == "Complete" }
  has_many :data_files
  has_many :result_files
  accepts_nested_attributes_for :data_files, :allow_destroy => true
  accepts_nested_attributes_for :result_files, :allow_destroy => true
  serialize :current_changes
  serialize :assignment

  # Get priority items for modal. 
  def self.priority_widget
    pending = Request.where("status = ?", "Pending").order! 'created_at DESC'
    high_p = pending.where("priority = ?", "High Priority")
    normal_p = pending.where("priority = ?", "Priority")
    low_p = pending.where("priority = ?", "Low Priority")
    time_perm = pending.where("priority = ?", "Time Permitting")
    return priority_list = {
        "high" => high_p,
        "normal" => normal_p,
        "low" => low_p,
        "time_permitting" => time_perm
    }
  end

  # Get ongoing requests.
  def self.active_requests
    ongoing_requests = ActiveSupport::OrderedHash.new
    max_length = 1
    User.where("admin = ?", true).each do |user|
      requests = Request.where("(name = ? OR customer = ? OR assignment like ?) AND status = ?", user.login, user.login, "%#{user.login}%", "Ongoing").sort_by &:updated_at
      if requests.length > max_length
        max_length = requests.length
      end
      ongoing_requests[user.get_name] = requests
    end
    return ongoing_requests, max_length
  end

  #
  def handle_est_hours
    if self.tothours and not self.esthours
      self.esthours = self.tothours
    end
  end

  # Updates the versioning for the status.
  def set_stathist
    stats = ["Pending", "Ongoing", "Complete"]
    if self.stathist.nil? or self.status_changed?
      res = ""
      stats.each do |sta|
        if sta == self.status
          if self.stathist.nil?
            self.stathist = res + sta + ": " + Date.today.to_s + "\n"
          else
            self.stathist += res + sta + ": " + Date.today.to_s + "\n"
          end
          return
        elsif self.stathist.nil? or not self.stathist.include? sta
          res += sta + ": " + Date.today.to_s + "\n"
        end
      end
    end
  end

  # Gets users in a view ready format. Adds captitalisation etc.
  def get_users_for_view(assignment = self.assignment)
    if assignment
      Array(assignment).map { |a| get_name(a) }.reject { |c| c.empty? }.join(", ")
    end
  end

  def get_name(name = self.name)
    puts "#{self.id}, #{self.name}, #{self.title}"
    name.sub('.', ' ').split.map(&:capitalize).join(' ')
  end

  # Determines whether a true edit has been made, as opposed
  # to just a modified or updated change.
  def check_for_edits_email
    latest_version = get_versions[0]
    number_of_edits_total = latest_version.lines.count
    number_of_edits_non_essential = 1 #0 + 1 to ignore updated_at

    if number_of_edits_total - number_of_edits_non_essential > 0
      return true
    else
      return false
    end
  end

  def send_edit_email
    changes = self.get_changed_attributes
    if changes != self.current_changes
      Emailer.edit_request(self.id).deliver_later!
    end
    self.update_column(:current_changes, changes.to_yaml)
  end


  # Returns changes from papertrail, minus the excepted ones.
  def get_changed_attributes
    return self.versions.last.changeset.except("updated_at", "created_at", "stathist")
  end

  # Gets all versions for form view.
  def get_versions
    versions = []
    self.versions.reverse.each do |version|
      versions << cleanup_version_html(version.changeset)
    end
    return versions
  end

  # Gets last version.
  def get_version_latest
    return cleanup_version_html(get_changed_attributes)
  end

  # Converts versions to HTML readable format.
  def cleanup_version_html (version)
    cleaned_version = ''
    version.each do |key, changes|
      prev_version = changes.first
      curr_version = changes.last
      if key == "assignment"
        prev_version = self.get_users_for_view prev_version
        curr_version = self.get_users_for_view curr_version
      end
      if prev_version.nil? || prev_version.to_s.empty?
        prev_version = 'NO VALUE'
      elsif curr_version.nil? || curr_version.to_s.empty?
        curr_version = 'NO VALUE'
      end
      cleaned_version += "<h4>" + key.capitalize.scrub + ':</h4> ' + prev_version.to_s.scrub + ' <b> => </b> ' + curr_version.to_s.scrub
    end
    return cleaned_version + "<hr>"
  end
end
