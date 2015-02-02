class AddCustomerToRequests < ActiveRecord::Migration
  def change
  	add_column :requests, :customer, :string
  end
end
