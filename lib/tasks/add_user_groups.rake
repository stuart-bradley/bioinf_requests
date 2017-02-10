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

  desc "LDAP Test"
  task ldap: :environment do
    ldap = Net::LDAP.new :host => "10.10.40.10",
                         :port => 636,
                         :encryption => :simple_tls,
                         :base => "DC=lt,DC=local",
                         :auth => {
                             :method => :simple,
                             :username => "",
                             :password => ""
                         }
    if ldap.bind
      # Redundant? Sure - the code will be 0 and the message will be "Success".
      puts "Connection successful!  Code:  #{ldap.get_operation_result.code}, message: #{ldap.get_operation_result.message}"
      ldap.search(:base => "OU=Lanzatech Users,DC=lt,DC=local", :filter => Net::LDAP::Filter.eq("cn", "Sahil*"), :attributes => ["cn", "department"], :return_result => false) do |entry|
        entry.each do |attr, values|
          puts "#{attr}: #{values.first}"
        end
      end
    else
      puts "Connection failed!  Code:  #{ldap.get_operation_result.code}, message: #{ldap.get_operation_result.message}"
    end
  end
end

def user_groups_hash
  user_groups = {}
  accepted_groups = ["Synthetic Biology", "Engineering", "Process Engineering", "Fermentation", "Bioinformatics", "Process Validation", "CSO"]

  CSV.foreach('lib/tasks/Names_Phones.csv', :headers => true) do |row|
    if accepted_groups.include?(row[0]) and not (row[1].nil? or row[1].empty? or row[1].include?(" Lab") or row[1].include?(" Kitchen"))
        if row[1] == "Sean Simpson"
          user_groups["sean"] = "CSO"
        else
          user_groups[row[1].downcase.gsub!(' ', '.')] = row[0]
        end
    end
  end
  user_groups
end
