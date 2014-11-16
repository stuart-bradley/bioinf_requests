json.array!(@data_files) do |data_file|
  json.extract! data_file, :id, :request_id, :attachment_uploader
  json.url data_file_url(data_file, format: :json)
end
