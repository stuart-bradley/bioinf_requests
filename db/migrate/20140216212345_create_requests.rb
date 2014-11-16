class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :title
      t.string :name
      t.text :description
      t.string :attachment

      t.timestamps
    end
  end
end
