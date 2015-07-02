class Request < ActiveRecord::Base
  before_save :handle_assignment
  before_save :set_stathist
	has_paper_trail
  validates :name, presence: true # Make sure the owner's name is present.
  validates :title, presence: true
  validates_with OngoingValidator
  validates_presence_of :esthours, :if => lambda {self.status == "Ongoing"}
  validates_presence_of :tothours, :if => lambda {self.status == "Complete"}
  has_many :data_files
  has_many :result_files
  has_one :employee
  accepts_nested_attributes_for :data_files, :allow_destroy => true
	accepts_nested_attributes_for :result_files, :allow_destroy => true
  accepts_nested_attributes_for :employee

  HUMANIZED_ATTRIBUTES = {
    :name => "Name",
    :title => "Title",
    :description => "Description",
    :status => "Status",
    :assignment => "Assignment",
    :result => "Result",
    :stathist => "Status History",
    :customer => "Customer",
    :priority => "Priority",
    :esthours => "Estimated Hours",
    :tothours => "Total Hours"
  }

  # Humanized Attribute for Error messages.
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Get priority items for modal. 
  def self.priority_widget
    high_p = Request.where("priority = ? AND status = ?", "High Priority", "Pending").order! 'created_at DESC'
    normal_p = Request.where("priority = ? AND status = ?", "Priority", "Pending").order! 'created_at DESC'
    low_p = Request.where("priority = ? AND status = ?", "Low Priority", "Pending").order! 'created_at DESC'
    time_perm = Request.where("priority = ? AND status = ?", "Time Permitting", "Pending").order! 'created_at DESC'

    return priority_list = {
      "high" => high_p,
      "normal" => normal_p,
      "low" => low_p,
      "time_permitting" => time_perm
    }
  end

  # Given two dates, return a number of results.
  def self.manager_analytics (min, max)
    analytics_list = {}

    if min != "" and max != ""
      min = min.to_date.to_datetime
      max = max.to_date.to_datetime

      # Before.
      analytics_list["before_pending"] = Request.where("created_at <= ? AND status = ?", min, "Pending")
      analytics_list["before_ongoing"] = Request.where("created_at <= ? AND status = ?", min, "Ongoing")
      analytics_list["before_completed_in_period"] = Request.where("created_at <= ? AND updated_at >= ? AND updated_at <= ? AND status = ?", min, min, max, "Complete")

      # During.
      analytics_list["during_pending"] = Request.where("created_at >= ? AND created_at <= ? AND status = ?", min, max, "Pending")
      analytics_list["during_ongoing"] = Request.where("created_at >= ? AND created_at <= ? AND status = ?", min, max, "Ongoing")
      analytics_list["during_completed"] = Request.where("created_at >= ? AND created_at <= ? AND status = ?", min, max, "Complete")

      # Totals.
      analytics_list["ongoing_pending"] = analytics_list["before_pending"].count + analytics_list["before_ongoing"].count + analytics_list["during_pending"].count + analytics_list["during_ongoing"].count
      analytics_list["completed"] = analytics_list["before_completed_in_period"].count + analytics_list["during_completed"].count
    end

    return analytics_list
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

  # Deals with the multiple user assignment, joins user array into string.
  def handle_assignment
    if assignment
      self.assignment = self.assignment.select(&:present?).join(';') 
    end
  end

  # Splits user string into array.
  def get_users
    if self.assignment
      self.assignment.split(';')
    end
  end

  # Gets users in a view ready format. Adds captitalisation etc.
  def get_users_for_view
    if self.assignment
      assign = self.assignment.split(';')
      st = ''
      assign.each do |a| 
        st += a.sub('.', ' ').split.map(&:capitalize).join(' ') + ', '
      end
      st[0..-3]
    end
  end

  def get_name
    self.name.sub('.', ' ').split.map(&:capitalize).join(' ')
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

  # Checks to see if the change is a new addition or not.
  # New additions are defined by prev_version "NO VALUE".
  def check_version_attribute_change(attribute)
    latest_version = get_versions[0]
    if latest_version.match(/^#{attribute}/i)
      relevant_string = latest_version[/^#{attribute}(.+)/i]
      if relevant_string.split.last == "NO VALUE"
        return ""
      else 
        return relevant_string.split.last
      end
    else 
      return ""
    end
  end

	def get_versions
    versions = []
    single_version = []

    self.versions.each do |version|
    	single_version = []
    	version.changeset.each do |key|
    	  single_version << key
    	end
    	versions << cleanup_version_html(single_version) 
    end
  return versions.reverse
  end

  def cleanup_version (version)
  	cleaned_version = ''
  	version.each do |change|
  	  prev_version = change[1][0]
  	  curr_version = change[1][1]
  	  if prev_version.nil?
  	  	prev_version = 'NO VALUE'
  	  elsif curr_version.nil?
  	  	curr_version = 'NO VALUE'
  	  end    	  	
  	  cleaned_version += change[0].capitalize + ': ' + prev_version.to_s + ' -> ' + curr_version.to_s + "\n"
  	end
  	return cleaned_version
  end

  def get_version_latest
    self.versions.last.changeset.each do |key|
      single_version << key
    end
    return cleanup_version_html(single_version) 
  end

  def cleanup_version_html (version)
    cleaned_version = ''
    version.each do |change|
      prev_version = change[1][0]
      curr_version = change[1][1]
      if prev_version.nil?
        prev_version = 'NO VALUE'
      elsif curr_version.nil?
        curr_version = 'NO VALUE'
      end         
      cleaned_version += change[0].capitalize + ': ' + prev_version.to_s + ' -> ' + curr_version.to_s + "<br />"
    end
    return cleaned_version
  end
end