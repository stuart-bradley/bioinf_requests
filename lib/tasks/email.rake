namespace :email do
  desc "Emails every admin user their list of ongoing and pending tasks"
  task pending_and_ongoing: :environment do
    User.where("admin = ?", true).each do |u|
      Emailer.delay.pending_and_ongoing_requests(u) if u.login == "stuart.bradley"
    end
  end
end
