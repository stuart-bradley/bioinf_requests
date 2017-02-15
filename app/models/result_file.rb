class ResultFile < ActiveRecord::Base
	mount_uploader :attachment_uploader, AttachmentUploader
	belongs_to :request

  def self.save_result_files(result_files, files_to_delete, request)
    ResultFile.where(:id => files_to_delete).destroy_all
    if result_files
      result_files['attachment_uploader'].each do |a|
        @result_file = request.result_files.create!(:attachment_uploader => a, :request_id => request.id)
      end
    end
  end
end
