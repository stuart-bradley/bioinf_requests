class User < ActiveRecord::Base
  before_validation :downcase_login

  def downcase_login
    self.login = login.downcase
  end

  def email
    self.login + "@lanzatech.com"
  end

  def get_name
    self.login.sub('.', ' ').split.map(&:capitalize).join(' ')
  end

  def user_analytics(requests)
    analytics_list = {}
    analytics_list["requests"] = requests
    analytics_list["requests_launched"] = analytics_list["requests"].length
    requests_completed = analytics_list["requests"].select { |x| x.status == "Complete" }
    analytics_list["requests_completed"] = requests_completed.length
    time_spent_per_request = []

    time_spent_per_stage = []

    requests_completed.each do |r|
      time_spent_per_request << [r.title, r.tothours, r.esthours]
      time_spent_per_stage << determine_pending_and_ongoing_times(r)
    end

    analytics_list["time_spent_per_request"] = time_spent_per_request
    analytics_list["time_spent_per_stage"] = time_spent_per_stage

    return analytics_list
  end

  def determine_pending_and_ongoing_times(r)
    res = []
    res << r.title
    stathist = r.stathist
    pending = r.created_at.to_date

    ongoing = Date.parse stathist.match(/Ongoing:\s(\d+-\d+-\d+)/)[-1]
    res << (pending..ongoing).count

    complete = Date.parse stathist.match(/Complete:\s(\d+-\d+-\d+)/)[-1]
    res << (ongoing..complete).count

    puts pending, ongoing, complete

    return res

  end

  # Given two dates, return a number of results.
  def manager_analytics (min, max)
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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable
end
