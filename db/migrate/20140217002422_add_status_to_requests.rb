class AddStatusToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :status, :string
  end
end
