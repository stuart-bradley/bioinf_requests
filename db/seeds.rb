# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Admins
User.create!({:login => "stuart.bradley", :admin => true})
User.create!({:login => "asela.dassanayake", :admin => true})
User.create!({:login => "wayne.mitchell", :admin => true})
User.create!({:login => "james.daniell", :admin => true})
User.create!({:login => "vini.reynoso", :admin => true})

