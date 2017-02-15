class AddCurrentChangesToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :current_changes, :text
  end
end
