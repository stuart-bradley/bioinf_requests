class AddDefaultValueToStatusAttribute < ActiveRecord::Migration
  def up
    change_column :requests, :status, :string, :default => 'Pending'
end

def down
    change_column :requests, :status, :string, :default => nil 
end
end
