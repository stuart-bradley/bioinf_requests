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

User.create!({:login => "michael.koepke", :admin => false})
User.create!({:login => "sean.simpson", :admin => false})
User.create!({:login => "rasmus.jensen", :admin => false})
User.create!({:login => "james.behrendorff", :admin => false})
User.create!({:login => "bjorn.heijstra", :admin => false})
User.create!({:login => "shilpa.nagaraju", :admin => false})
User.create!({:login => "katie.smart", :admin => false})
User.create!({:login => "christophe.mihalcea", :admin => false})
User.create!({:login => "eric.liew", :admin => false})
User.create!({:login => "alex.mueller", :admin => false})
User.create!({:login => "jared.prinsloo", :admin => false})

