# rails runner lib/add_user_groups.rb

user_groups = {
    "stuart.bradley" => "systems biology"
}

user_groups.each do |key, value|
  user = User.where("login == ?", key).first
  if user
    user.update(group: value)
  else
    User.create!({:login => key, :admin => false, :group => value})
  end
end