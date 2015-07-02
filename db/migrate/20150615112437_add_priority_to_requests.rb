class AddPriorityToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :priority, :string
  end
end
