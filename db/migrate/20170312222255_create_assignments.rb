class CreateAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :assignments do |t|
      t.integer :request_id
      t.integer :user_id
      t.boolean :customer
      t.boolean :assigned
      t.boolean :creator
      t.timestamps
    end
  end
end
