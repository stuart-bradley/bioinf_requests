namespace :database_changes do
  desc "Retractively adds last change set to current changes"
  task current_changes_up: :environment do
    Request.all.each do |r|
      r.update_column(:current_changes, r.get_changed_attributes.to_yaml)
    end
  end

  desc "Removes retroactive current_change param."
  task current_changes_down: :environment do
    Request.all.each do |r|
      r.update_column(:current_changes, nil)
    end
  end

  desc "Retractively adds last change set to current changes"
  task user_association_up: :environment do
    Request.all.each do |r|
      request_id = r.id
      creator_id = get_user_id(r.name)
      Assignment.create!({:request_id => request_id, :user_id => creator_id, :creator => true})

      if r.customer.present?
        customer_id = get_user_id(r.customer)
        Assignment.create!({:request_id => request_id, :user_id => customer_id, :customer => true})
      end

      if r.assignment.present?
        r.get_users.each do |u|
          user_id = get_user_id(u)
          Assignment.create!({:request_id => request_id, :user_id => user_id, :assigned => true})
        end
      end
    end
  end

  desc "Removes retroactive current_change param."
  task user_association_down: :environment do
    Assignment.delete_all
  end

  def get_user_id(login)
    corrections = {
        "micheal.koepke" => "michael.koepke",
        "wayne" => "wayne.mitchell",
        "stuart" => 'stuart.bradley',
        "asela" => "asela.dassanayake",
        "vini" => "vinicio.reynoso",
        "vini.reynoso" => "vinicio.reynoso",
        "sean.simpson" => "sean"

    }
    new_login = login.downcase.gsub(" ", ".")
    result = User.where(:login => new_login).first
    if result.nil?
      puts "login: #{login} new login: #{new_login}"
      result = User.where(:login => corrections[new_login]).first
    end
    result.id
  end
end
