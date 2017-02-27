require 'test_helper'

class ResultFileTest < ActiveSupport::TestCase
  test "result files modification" do
    request = Request.first
    assert_difference('ResultFile.count', -1) do
      ResultFile.save_result_files(nil, [ResultFile.first.id], request)
    end

    assert_difference('ResultFile.count') do
      resultfiles = {}
      resultfiles['attachment_uploader'] = ["Mystring"]
      ResultFile.save_result_files(resultfiles, [], request)
    end
  end
end
