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
end
