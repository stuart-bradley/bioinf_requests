# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
    :address => Rails.application.secrets.mailer_smtp_address,
    :port => Rails.application.secrets.mailer_smtp_port,
    :domain => Rails.application.secrets.mailer_smtp_domain,
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