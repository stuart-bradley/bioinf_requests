# Load the Rails application.
require File.expand_path('../application', __FILE__)

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the Rails application.
BioinfRequests::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
	:address => "smtp.office365.com",
    :port => 587,
    :domain => "lanzatech.com",
    :user_name => ENV['EMAIL'],
    :password => ENV['PASSWORD'],
    :authentication => :login, 
    :enable_starttls_auto => true
}

# ActionMailer::Base.smtp_settings = {
#       :address              => "smtp.gmail.com",
#       :port                 => 587,
#       :domain               => "gmail.com",
#       :user_name            => ENV['EMAIL'],
#       :password             => ENV['PASSWORD'],
#       :authentication       => :plain,
#       :enable_starttls_auto => true
# }