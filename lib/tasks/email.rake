namespace :email do
  desc "Emails every admin user their list of ongoing and pending tasks"
  task pending_and_ongoing: :environment do
    User.where("admin = ?", true).each do |u|
      if user_requests.length > 0
        #if u.login == "stuart.bradley"
        Emailer.delay.pending_and_ongoing_requests(u)
      end
    end

  end

end
