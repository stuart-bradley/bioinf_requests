class RemoveTextFieldLimits < ActiveRecord::Migration[5.0]
  def up
    change_column :requests, :description, :text, :limit => 4294967295
    change_column :requests, :result, :text, :limit => 4294967295
    change_column :requests, :current_changes, :text, :limit => 4294967295

    change_column :versions, :object, :text, :limit => 4294967295
    change_column :versions, :object_changes, :text, :limit => 4294967295
  end

  def down
    change_column :requests, :description, :text
    change_column :requests, :result, :text
    change_column :requests, :current_changes, :text

    change_column :versions, :object, :text
    change_column :versions, :object_changes, :text
  end
end
