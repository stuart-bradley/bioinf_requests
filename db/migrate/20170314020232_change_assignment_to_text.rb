class ChangeAssignmentToText < ActiveRecord::Migration[5.0]
  def up
    change_column :requests, :assignment, :text
  end

  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :requests, :assignment, :string
  end
end
