class AddStathistToRequests < ActiveRecord::Migration
  def change
  	add_column :requests, :stathist, :string
  end
end
