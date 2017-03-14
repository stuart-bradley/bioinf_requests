require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # Validation tests
  test "should not save request without title" do
    request = Request.new
    request.name = 'stuart.bradley'
    assert_not request.save, "Saved the request without a title"
  end

  test "should not save request without name" do
    request = Request.new
    request.title = 'test'
    assert_not request.save, "Saved the request without a name"
  end

  test "should not save ongoing request without assignment" do
    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    request.status = 'Ongoing'
    request.esthours = 0
    assert_not request.save, "Saved the request without an assignment"
  end

  test "should not save ongoing request without esthours" do
    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    request.status = 'Ongoing'
    request.assignment = 'stuart.bradley'
    assert_not request.save, "Saved the request without esthours"
  end

  test "should not save complete request without tothours" do
    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    request.status = 'Complete'
    request.assignment = 'stuart.bradley'
    request.esthours = 0
    assert_not request.save, "Saved the request without tothours"
  end

  # Method tests
  test "priority_widget should return a hash with atleast one request per field" do
    result_hash = Request.priority_widget
    result_hash.each do |k, v|
      assert_not_empty v, "#{k} does not contain any Request objects."
      v.each do |r|
        assert_kind_of Request, r, "#{k} contains an object that is not a Request."
      end
    end
  end

  test "active_requests should return a hash with only Ongoing Requests" do
    result_hash, max_length = Request.active_requests
    result_hash.each do |k, v|
      assert_not_empty v, "#{k} does not contain any Request objects."
      v.each do |r|
        assert_kind_of Request, r, "#{k} contains an object that is not a Request."
        assert_equal "Ongoing", r.status, "#{r.title} is not Ongoing."
      end
    end
  end

  test "handle_est_hours should add esthours if tothours is present and it's not" do
    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    request.status = 'Complete'
    request.tothours = 1

    request.handle_est_hours
    assert_equal request.tothours, request.esthours, "est and tot hours are not equal"

    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    request.status = 'Complete'
    request.esthours = 1
    request.tothours = 2

    request.handle_est_hours
    assert_not_equal request.tothours, request.esthours, "est and tot hours are equal"
  end

  test "set_stathist should set stathist to a specific string" do
    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    request.status = 'Ongoing'
    request.esthours = 1
    request.set_stathist
    assert_equal "Pending: #{Date.today.to_s}\nOngoing: #{Date.today.to_s}\n", request.stathist, "Unexpected stathist string."
  end

  test "get_users_for_view should return a prettified string" do
    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    request.assignment = ['stuart.bradley', 'wayne.mitchell']
    assert_equal 'Stuart Bradley, Wayne Mitchell', request.get_users_for_view, "Assignment did not prettify correctly."
  end

  test "get_name should return a prettified string" do
    request = Request.new
    request.title = 'test'
    request.name = 'stuart.bradley'
    assert_equal 'Stuart Bradley', request.get_name, "Name did not prettify correctly."
  end

  test "get_changed_attributes should return title change" do
    request = create_changed_request
    expected = {'title' => ['Request', 'Request Changed']}
    assert_equal expected, request.get_changed_attributes, "Changed attribute hashes differ."
  end

  test "get_version_latest should return a html version" do
    request = create_changed_request
    assert_equal "<h4>Title:</h4> Request <b> => </b> Request Changed<hr>", request.get_version_latest, "Changed attribute hashes differ."
  end
end
