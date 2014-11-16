class Emailer < ActionMailer::Base

  ActionMailer::Base.default_url_options[:host] = "http://reilly.lt.local:3000/" 

  ActionMailer::Base.default_url_options[:port] = 3000
  
  def new_request(id)
  	@request = Request.find(id)
  	emails = []
  	User.where(admin: true).each do |u|
  	  emails << u.email
  	end
    employee = User.where(login: @request.name).first
    if employee != nil
      emails << employee.email
    end
   	mail :to => emails, :from => "SynBioAdmin@lanzatech.onmicrosoft.com", :subject => "New Request: '#{@request.title}'"
  end

  def edit_request(id)
    @request = Request.find(id)
    employee = User.where(login: @request.name).first
    if @request.check_for_edits_email == false
      return
    end

  	if @request.assignment != nil
      emails = []
      User.where(login: @request.get_users).each do |u|
        emails << u.email
      end
      mail :to => emails, :from => "SynBioAdmin@lanzatech.onmicrosoft.com", :subject => "Request: '#{@request.title}' has been edited"
  	end 
  end 

  def edit_status(id)
    @request = Request.find(id)
    employee = User.where(login: @request.name).first
    
    edit_type_status = @request.check_version_attribute_change("Status")

    if edit_type_status.length > 0
      if employee != nil
        mail :to => employee.email, :from => "SynBioAdmin@lanzatech.onmicrosoft.com", :subject => "Request: '#{@request.title}' has changed status", template_name: 'edit_status'
      end 
    end
  end

  def edit_assignment(id)
    @request = Request.find(id)
    employee = User.where(login: @request.name).first
    
    edit_type_assignment = @request.check_version_attribute_change("Assignment")

    if edit_type_assignment.length > 0
      if employee != nil
        emails = []
        emails << employee.email
        User.where(login: @request.get_users).each do |u|
          emails << u.email
        end
        mail :to => emails, :from => "SynBioAdmin@lanzatech.onmicrosoft.com", :subject => "Request: '#{@request.title}' has been assigned", template_name: 'edit_assignment'
      end 
    end
  end

  def new_model_request()
    emails = []
    User.where(admin: true).each do |u|
      emails << u.email
    end
    mail :to => emails, :from => "SynBioAdmin@lanzatech.onmicrosoft.com", :subject => "New Model Request"
  end
end
