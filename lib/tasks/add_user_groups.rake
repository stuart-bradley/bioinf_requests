require 'csv'

namespace :add_user_groups do
  desc "Populates groups for all users"
  task all: :environment do
    user_groups = user_groups_hash
    user_groups.each do |key, value|
      user = User.where("login = ?", key).first
      if user
        user.update!(:group => value)
        puts "#{user.login} updated. Group: #{value}"
      else
        is_admin = false
        if value == "Bioinformatics"
          is_admin = true
        end
        User.create!({:login => key, :admin => is_admin, :group => value})
        puts "#{key} created. Group: #{value}"
      end
    end
  end

  desc "Populates groups for specific users"
  task some: :environment do |task, args|
    user_groups = user_groups_hash
    args.extras.each do |name|
      name = name.to_s
      user = User.where("login = ?", name).first
      if user
        if user_groups.has_key?(name)
          user.update!(:group => user_groups[name])
          puts "#{user.login} updated. Group: #{value}"
        end
      else
        puts "#{name} not found."
      end
    end
  end
end

def user_groups_hash
  user_groups = {}
  accepted_groups = ["Synthetic Biology", "Engineering", "Process Engineering", "Fermentation", "Bioinformatics", "Process Validation", "CSO"]

  CSV.foreach('lib/tasks/Names_Phones.csv', :headers => true) do |row|
    if not (row[1].nil? or row[1].empty? or row[1].include?(" Lab") or row[1].include?(" Kitchen"))
      if accepted_groups.include?(row[0])
        if row[1] == "Sean Simpson"
          user_groups["sean"] = "CSO"
        else
          user_groups[row[1].downcase.gsub!(' ', '.')] = row[0]
        end
      end
    end
  end
  user_groups
end
