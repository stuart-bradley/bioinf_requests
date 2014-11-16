class Request < ActiveRecord::Base
  before_save :handle_assignment
	has_paper_trail
  validates :name, presence: true # Make sure the owner's name is present.
  validates :title, presence: true
  has_many :data_files
  has_many :result_files
  has_one :employee
  accepts_nested_attributes_for :data_files, :allow_destroy => true
	accepts_nested_attributes_for :result_files, :allow_destroy => true
  accepts_nested_attributes_for :employee

   def handle_assignment
    if assignment
      self.assignment = self.assignment.select(&:present?).join(';') 
    end
  end

  def get_users
    if self.assignment
      self.assignment.split(';')
    end
  end

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

  def check_for_edits_email
    latest_version = get_versions[0]
    number_of_edits_total = latest_version.lines.count
    number_of_edits_non_essential = 1 #0 + 1 to ignore updated_at

    if check_version_attribute_change("Status").length > 0
      number_of_edits_non_essential += 1
    end

    if check_version_attribute_change("Assignment").length > 0
      number_of_edits_non_essential += 1
    end 

    if number_of_edits_total - number_of_edits_non_essential > 0
      return true
    else 
      return false
    end
  end

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
    	versions << cleanup_version(single_version) 
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
end