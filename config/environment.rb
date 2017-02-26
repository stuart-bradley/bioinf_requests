# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address => "smtp.office365.com",
    :port => 587,
    :domain => "lanzatech.com",
    :user_name => Rails.application.secrets.mailer_email,
    :password => Rails.application.secrets.mailer_password,
    :authentication => :login,
    :enable_starttls_auto => true
}

# ActionMailer::Base.smtp_settings = {
#       :address              => "smtp.gmail.com",
#       :port                 => 587,
#       :domain               => "gmail.com",
#       :user_name => Rails.application.secrets.mailer_email,
#       :password => Rails.application.secrets.mailer_password,
#       :authentication       => :plain,
#       :enable_starttls_auto => true
# }