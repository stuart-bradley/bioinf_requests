require 'csv'

namespace :add_user_groups do
  @ldap_groups = {
      "Team_BioInformatics" => "Bioinformatics",
      "Team_Fermentation" => "Fermentation",
      "Team_Synthetic Biology" => "Synthetic Biology",
      "Team_Eng Process Engineering" => "Process Engineering",
      "Team_Eng Global Operations" => "Engineering",
      "Team_Eng Design Development" => "Engineering",
      "Team_Process Validation" => "Process Validation"
  }

  @users_with_multiple_groups = {}

  @special_cases = {"Heijstra" => "bjorn.heijstra",
                    "Sean Simpson" => "sean"}

  desc "Populates groups for all users"
  task all: :environment do
    user_groups = get_all_users_and_groups
    user_groups.each do |key, value|
      if value.length > 1
        @users_with_multiple_groups[key] = value
        next
      else
        value = value.first
      end
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
    puts @users_with_multiple_groups
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

  def get_all_users_and_groups
    people = {}
    ldap = ldap_setup
    if ldap.bind
      @ldap_groups.keys.each do |group|
        ldap.search(:base => "CN=#{group},OU=Departments,OU=Lanzatech Groups,DC=lt,DC=local", :attributes => ["member"], :return_result => false) do |entry|
          entry.each do |attr, values|
            if attr == "dn"
              next
            else
              values.each do |person|
                hash_key_in_s = person[Regexp.union(@special_cases.keys)]
                if hash_key_in_s
                  person = @special_cases[hash_key_in_s]
                else
                  person = person[/CN\=([\w\s\-]+),/, 1].gsub(" ", ".").downcase
                end
                if person.start_with?("team_")
                  next
                elsif people.has_key?(person)
                  people[person] << @ldap_groups[group]
                else
                  people[person] = [@ldap_groups[group]]
                end
              end
            end
          end
        end
      end
      return people
    else
      puts "Connection failed!  Code:  #{ldap.get_operation_result.code}, message: #{ldap.get_operation_result.message}"
    end
  end

  def ldap_setup
    Net::LDAP.new :host => "10.10.40.10",
                  :port => 636,
                  :encryption => :simple_tls,
                  :base => "OU=Lanzatech Users,DC=lt,DC=local",
                  :auth => {
                      :method => :simple,
                      :username => ENV['LDAP_LOGIN'],
                      :password => ENV['LDAP_PASSWORD']
                  }
  end
end

