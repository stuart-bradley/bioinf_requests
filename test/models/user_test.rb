require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = User.where(:login => 'stuart.bradley').first
    @manager = User.where(:login => 'wayne.mitchell').first
    @customer = User.where(:login => 'sean.simpson').first
  end

  # Method tests.
  test "downcase_login should downcase an upcased login" do
    assert_equal "stuart.bradley", @user.login, "Login not downcased."
    @user.login = "Stuart.Bradley"
    assert_equal "stuart.bradley", @user.downcase_login, "Login not downcased."
    @user.login = 'stuart.bradley'
  end

  test "email should append @lanzatech.com" do
    assert_equal 'stuart.bradley@lanzatech.com', @user.email, "Email not correct."
  end

  test "get_name should prettify login" do
    assert_equal 'Stuart Bradley', @user.get_name, "Name not prettified."
  end

  test "get_name_link should get name for url" do
    assert_equal 'stuartbradley', @user.get_name_link, "Name not converted for HTML."
  end

  test "user_analytics should return a populated hash of specific keys" do
    requests = Request.where("updated_at >= ? AND updated_at <= ?", (Date.today - 1.months), Date.today)
    user_requests = requests.where("name = ? OR customer = ? OR assignment like ?", @user.login, @user.login, @user.login)
    analytics_list = User.user_analytics(user_requests)

    assert (analytics_list.has_key? "requests"), "Missing key requests."
    assert_kind_of ActiveRecord::Relation, analytics_list["requests"], "requests is an object that is not an Array."

    ["time_spent_per_request", "time_spent_per_stage"].each do |k|
      assert (analytics_list.has_key? k), "Missing key #{k}."
      assert_kind_of Array, analytics_list[k], "#{k} is an object that is not an Array."
    end

    ["requests_launched", "requests_completed"].each do |k|
      assert (analytics_list.has_key? k), "Missing key #{k}."
      assert_kind_of Integer, analytics_list[k], "#{k} is an object that is not an Integer."
    end
  end

  test "manager_analytics should return a populated hash of specific keys" do
    analytics_list = User.manager_analytics((Date.today - 1.months), Date.today)

    ["before_pending", "before_ongoing", "before_completed_in_period", "during_pending", "during_ongoing", "during_completed"].each do |k|
      assert (analytics_list.has_key? k), "Missing key #{k}."
      assert_kind_of (ActiveRecord::Relation || nil), analytics_list[k], "#{k} is an object that is not an Array."
    end

    ["ongoing_pending", "completed"].each do |k|
      assert (analytics_list.has_key? k), "Missing key #{k}."
      assert_kind_of Integer, analytics_list[k], "#{k} is an object that is not an Integer."
    end
  end

  test "requests_by_group should have some Bioinformatics requests" do
    requests = Request.where("updated_at >= ? AND updated_at <= ?", (Date.today - 1.months), Date.today)
    analytics_list = User.requests_by_group(requests)

    analytics_list.each_with_index do |value, index|
      if value == "Bioinformatics"
        assert (analytics_list[index+1] > 0), "Bioinformatics does have any requests."
        break
      end
    end
  end
end
