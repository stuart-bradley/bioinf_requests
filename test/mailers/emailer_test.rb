require 'test_helper'

class EmailerTest < ActionMailer::TestCase
  test "new request" do
    request = Request.first
    email = Emailer.new_request(request.id)

    assert_emails 1 do
      email.deliver!
    end

    assert_equal [Rails.application.secrets.mailer_email], email.from, "Sender is incorrect."
    assert (same_elements? email.to, ['stuart.bradley@lanzatech.com', 'wayne.mitchell@lanzatech.com']), "Recievers are incorrect."
    assert_equal "New Request: '#{request.title}'", email.subject
  end

  test "edit request" do
    request = create_changed_request
    email = Emailer.edit_request(request.id)

    assert_emails 1 do
      email.deliver!
    end

    assert_equal [Rails.application.secrets.mailer_email], email.from, "Sender is incorrect."
    assert_equal ['stuart.bradley@lanzatech.com'], email.to, "Reciever is incorrect."
    assert_equal "Request: '#{request.title}' has been edited", email.subject, "Subject is incorrect."

    request.assignment = 'stuart.bradley'
    request.save

    email = Emailer.edit_request(request.id)

    assert_emails 1 do
      email.deliver!
    end
    assert_equal "Request: '#{request.title}' has been assigned", email.subject, "Subject is incorrect."

    request.status = 'Ongoing'
    request.esthours = 1
    request.tothours = 1
    request.save

    request.status = 'Complete'
    request.save

    email = Emailer.edit_request(request.id)

    assert_emails 1 do
      email.deliver!
    end
    assert_equal "Request: '#{request.title}' has changed status", email.subject, "Subject is incorrect."
  end

  test "pending_and_ongoing_requests" do
    user = User.where(:login => 'stuart.bradley').first
    email = Emailer.pending_and_ongoing_requests(user)

    assert_emails 1 do
      email.deliver!
    end

    assert_equal [Rails.application.secrets.mailer_email], email.from, "Sender is incorrect."
    assert_equal ['stuart.bradley@lanzatech.com'], email.to, "Reciever is incorrect."
    assert_equal "Weekly Request Summary", email.subject, "Subject is incorrect."
  end

  test "no_user_group" do
    email = Emailer.no_user_group('stuart.bradley')

    assert_emails 1 do
      email.deliver!
    end

    assert_equal [Rails.application.secrets.mailer_email], email.from, "Sender is incorrect."
    assert_equal ['stuart.bradley@lanzatech.com'], email.to, "Reciever is incorrect."
    assert_equal "[DEV] Missing User Group", email.subject, "Subject is incorrect."
  end
end
