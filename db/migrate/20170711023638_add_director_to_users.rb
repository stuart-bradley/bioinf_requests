class AddDirectorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :director, :boolean, :default => false
  end
end
