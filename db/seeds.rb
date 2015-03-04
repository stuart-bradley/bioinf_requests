# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all

# Manager
User.create!({:login => "wayne.mitchell", :admin => true, :manager => true})

# Admins
User.create!({:login => "stuart.bradley", :admin => true})
User.create!({:login => "asela.dassanayake", :admin => true})
User.create!({:login => "james.daniell", :admin => true})
User.create!({:login => "vinicio.reynoso", :admin => true})
User.create!({:login => "audrey.harris", :admin => true})


# Synthetic Biology
User.create!({:login => "james.behrendorff", :admin => false})
User.create!({:login => "eric.liew", :admin => false})
User.create!({:login => "rasmus.jensen", :admin => false})
User.create!({:login => "simon.segovia", :admin => false})
# Because Sean has to be difficult - Could cause compatiability issues. 
User.create!({:login => "sean", :admin => false})
User.create!({:login => "naomi.davies", :admin => false})
User.create!({:login => "loan.tran", :admin => false})
User.create!({:login => "ching.leang", :admin => false})
User.create!({:login => "alex.mueller", :admin => false})
User.create!({:login => "michael.koepke", :admin => false})
User.create!({:login => "alex.juminaga", :admin => false})
User.create!({:login => "shilpa.nagaraju", :admin => false})
User.create!({:login => "archer.smith", :admin => false})
User.create!({:login => "ryan.tappel", :admin => false})
User.create!({:login => "robert.nogle", :admin => false})
User.create!({:login => "andrea.schoen", :admin => false})
User.create!({:login => "arthur.shockley", :admin => false})
User.create!({:login => "audrey.harris", :admin => false})

# Fermentation
User.create!({:login => "katie.smart", :admin => false})
User.create!({:login => "joe.tizard", :admin => false})
User.create!({:login => "mohammed.ali", :admin => false})
User.create!({:login => "nick.bourdakos", :admin => false})
User.create!({:login => "christophe.mihalcea", :admin => false})
User.create!({:login => "mike.mawdsley", :admin => false})
User.create!({:login => "san.ly", :admin => false})
User.create!({:login => "tanus.abdalla", :admin => false})
User.create!({:login => "wyatt.allen", :admin => false})
User.create!({:login => "josh.conolly", :admin => false})
User.create!({:login => "jason.greene", :admin => false})
User.create!({:login => "amy.quattlebaum", :admin => false})
User.create!({:login => "grant.hawkins", :admin => false})
User.create!({:login => "michael.martin", :admin => false})
User.create!({:login => "robin.mckoin", :admin => false})


