class Assignment < ApplicationRecord
  belongs_to :request
  belongs_to :user

  def self.save_assignment(request_id, user_id, creator = false, customer = false, assigned = false)
    Assignment.create!(:request_id => request_id, :user_id => user_id, :creator => creator, :customer => customer, :assigned => assigned)
  end

  def self.get_user_id(login, use_login = true)
    if use_login
      User.where(:login => login).first.id
    else
      User.where(:id => login).first.id
    end
  end

  def self.handle_request(request_id, creator, assignment, customer, use_login = true)
    Assignment.where(:request_id => request_id).delete_all

    creator_id = self.get_user_id(creator)
    self.save_assignment(request_id, creator_id, true, false, false)

    if customer.present?
      customer_id = self.get_user_id(customer)
      self.save_assignment(request_id, customer_id, false, true, false)
    end

    if assignment.present?
      assignment.each do |u|
        assignment_id = self.get_user_id(u)
        self.save_assignment(request_id, assignment_id, false, false, true)
      end
    end
  end
end
