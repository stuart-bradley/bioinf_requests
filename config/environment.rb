# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
BioinfRequests::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

# ActionMailer::Base.smtp_settings = {
#    :address => "smtp.gmail.com",
#    :port => 587,
#    :domain => "gmail.com",
#    :user_name => "stuy.bradley@gmail.com",
#    :password => "Br@dley1$",
#    :authentication => "plain",
#    :enable_starttls_auto => true
# }

ActionMailer::Base.smtp_settings = {
	:address => "smtp.office365.com",
    :port => 587,
    :domain => "lanzatech.com",
    :user_name => "SynBioAdmin@lanzatech.onmicrosoft.com",
    :password => "$yn8i0LZ",
    :authentication => :login, 
    :enable_starttls_auto => true
}

# ActionMailer::Base.smtp_settings = {
# 	:address => "smtp.office365.com",
#     :port => '587',
#     :domain => "lanzatech.com",
#     :user_name => "Stuart.Bradley@lanzatech.com",
#     :password => "Hockey123",
#     :authentication => :login, 
#     :enable_starttls_auto => true
# }

