class DataFile < ActiveRecord::Base
	mount_uploader :attachment_uploader, AttachmentUploader
	belongs_to :request

  def self.save_data_files(data_files, files_to_delete, request)
    DataFile.where(:id => files_to_delete).destroy_all
    if data_files
      data_files['attachment_uploader'].each do |a|
        @data_file = request.data_files.create!(:attachment_uploader => a, :request_id => request.id)
      end
    end
  end

end
