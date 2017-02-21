class Emailer < ActionMailer::Base

  ActionMailer::Base.default_url_options[:host] = "http://blunt.lt.local:3000/"

  ActionMailer::Base.default_url_options[:port] = 3000

  def new_request(id)
    begin
      @request = Request.find(id)
      emails = []
      User.where(admin: true).each do |u|
        emails << u.email
      end
      employee = User.where(login: @request.name).first
      if employee.present?
        emails << employee.email
      end

      if @request.customer.present?
        cust = User.where(login: @request.customer).first
        if cust.present?
          emails << cust.email
        end
      end

      mail :to => emails, :from => ENV['EMAIL'], :subject => "New Request: '#{@request.title}'"
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end

  def edit_request(id)
    begin

      @request = Request.find(id)

      emails = []
      User.where(login: @request.get_users).each do |u|
        emails << u.email
      end

      if @request.customer.present?
        cust = User.where(login: @request.customer).first
        if cust.present?
          emails << cust.email
        end
      end

      changes = @request.get_changed_attributes

      if changes.any?
        if changes.length == 1
          if changes.has_key?("assignment")
            mail :to => emails, :from => ENV['EMAIL'], :subject => "Request: '#{@request.title}' has been assigned", template_name: 'edit_assignment'
          elsif changes.has_key?("status")
            mail :to => emails, :from => ENV['EMAIL'], :subject => "Request: '#{@request.title}' has changed status", template_name: 'edit_status'
          else
            mail :to => emails, :from => ENV['EMAIL'], :subject => "Request: '#{@request.title}' has been edited"
          end
        else
          mail :to => emails, :from => ENV['EMAIL'], :subject => "Request: '#{@request.title}' has been edited"
        end
      end

    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end

  def new_model_request(user, requests)
    emails = []
    User.where(admin: true).each do |u|
      emails << u.email
    end
    mail :to => emails, :from => "SynBioAdmin@lanzatech.onmicrosoft.com", :subject => "New Model Request"
  end

  def pending_and_ongoing_requests(u)
    begin
      @user = u
      requests = Request.where("status = ? OR status = ?", "Pending", "Ongoing")
      user_requests = requests.select { |x| (x.name == u.login || (x.get_users.include?(u.login) rescue false)) }
      o = user_requests.select { |x| x.status == "Ongoing" }
      p = user_requests.select { |x| x.status == "Pending" }
      @ongoing = o.sort_by &:updated_at
      @pending = p.sort_by &:updated_at
      mail :to => @user.email, :from => ENV['EMAIL'], :subject => "Weekly Request Summary", template_name: 'pending_and_ongoing_requests'
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end

  def no_user_group(name)
    begin
      @name = name
      mail :to => "stuart.bradley@lanzatech.com", :from => ENV['EMAIL'], :subject => "[DEV] Missing User Group", template_name: 'no_user_group'
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end
end
