# rails runner lib/add_user_groups.rb

require 'csv'

user_groups = {
    "Synthetic Biology" => [],
    "Engineering" => [],
    "Process Engineering" => [],
    "Fermentation" => [],
    "Bioinformatics" => [],
    "Process Validation" => [],
    "CSO" => []
}

CSV.foreach('lib/Names_Phones.csv', :headers => true) do |row|
  if user_groups.key?(row[0])
    if not (row[1].nil? or row[1].empty? or row[1].include?(" Lab") or row[1].include?(" Kitchen"))
      if row[1] == "Sean Simpson"
        user_groups["CSO"] << "sean"
      else
        user_groups[row[0]] << row[1].downcase.gsub!(' ', '.')
      end
    end
  end
end

user_groups.each do |key, value|
  value.each do |name|
    user = User.where("login = ?", name).first
    if user
      user.update!(:group => key)
    else
      User.create!({:login => name, :admin => false, :group => key})
    end
  end
end


