class ResultFile < ActiveRecord::Base
	mount_uploader :attachment_uploader, AttachmentUploader
	belongs_to :request
end
