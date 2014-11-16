class AddJobOwnerToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :assignment, :string
  end
end
