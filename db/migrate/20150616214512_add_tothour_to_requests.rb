class AddTothourToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :tothours, :integer
  end
end
