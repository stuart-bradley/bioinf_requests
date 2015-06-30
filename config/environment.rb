# Load the Rails application.
require File.expand_path('../application', __FILE__)
app_env_vars = File.join(Rails.root, 'config', 'initializers', 'app_env_vars.rb')
load(app_env_vars)  if File.exists?(app_env_vars)

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