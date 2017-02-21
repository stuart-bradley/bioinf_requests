namespace :email do
  desc "Emails every admin user their list of ongoing and pending tasks"
  task pending_and_ongoing: :environment do
    requests = Request.where("status = ? OR status = ?", "Pending", "Ongoing")
    User.where("admin = ?", true).each do |u|
      user_requests = requests.select { |x| (x.name == u.login || (x.get_users.include?(u.login) rescue false)) }
      if user_requests.length > 0
        #if u.login == "stuart.bradley"
        ongoing = user_requests.select { |x| x.status == "Ongoing" }
        pending = user_requests.select { |x| x.status == "Pending" }
        Emailer.pending_and_ongoing_requests(u, ongoing, pending)
      end
    end

  end

end
