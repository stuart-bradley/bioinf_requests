class Emailer < ActionMailer::Base
  helper RequestsHelper

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

      mail :to => emails.uniq, :from => Rails.application.secrets.mailer_email, :subject => "New Request: '#{@request.title}'"
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end

  def edit_request(id)
    begin

      @request = Request.find(id)

      emails = []
      User.where(login: @request.assignment).each do |u|
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

      changes = @request.get_changed_attributes

      if changes.any?
        if changes.length == 1
          if changes.has_key?("assignment")
            mail :to => emails.uniq, :from => Rails.application.secrets.mailer_email, :subject => "Request: '#{@request.title}' has been assigned", template_name: 'edit_assignment'
          elsif changes.has_key?("status")
            mail :to => emails.uniq, :from => Rails.application.secrets.mailer_email, :subject => "Request: '#{@request.title}' has changed status", template_name: 'edit_status'
          else
            mail :to => emails.uniq, :from => Rails.application.secrets.mailer_email, :subject => "Request: '#{@request.title}' has been edited"
          end
        else
          mail :to => emails.uniq, :from => Rails.application.secrets.mailer_email, :subject => "Request: '#{@request.title}' has been edited"
        end
      end

    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end

  def pending_and_ongoing_requests(u)
    begin
      @user = u
      requests = Request.where("status = ? OR status = ?", "Pending", "Ongoing")
      user_requests = requests.where("name = ? OR assignment like ?", u.login, "%#{u.login}%")
      if user_requests.length > 0
        o = user_requests.select { |x| x.status == "Ongoing" }
        p = user_requests.select { |x| x.status == "Pending" }
        @ongoing = o.sort_by &:updated_at
        @pending = p.sort_by &:updated_at
        mail :to => @user.email, :from => Rails.application.secrets.mailer_email, :subject => "Weekly Request Summary", template_name: 'pending_and_ongoing_requests'
      end
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end

  def no_user_group(name)
    begin
      @name = name
      mail :to => "stuart.bradley@lanzatech.com", :from => Rails.application.secrets.mailer_email, :subject => "[DEV] Missing User Group", template_name: 'no_user_group'
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.debug "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map { |s| "\t#{s}" }
    end
  end
end
