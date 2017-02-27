require 'test_helper'

class DataFileTest < ActiveSupport::TestCase
  test "data files modification" do
    request = Request.first
    assert_difference('DataFile.count', -1) do
      DataFile.save_data_files(nil, [DataFile.first.id], request)
    end

    assert_difference('DataFile.count') do
      datafiles = {}
      datafiles['attachment_uploader'] = ["Mystring"]
      DataFile.save_data_files(datafiles, [], request)
    end
  end
end
