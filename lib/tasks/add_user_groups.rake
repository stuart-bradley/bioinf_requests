require 'csv'

namespace :add_user_groups do
  desc "Populates groups for all users"
  task all: :environment do
    UserGroups.all
  end

  desc "Populates groups for specific users"
  task some: :environment do |task, args|
    UserGroups.some(args.extras)
  end
end

