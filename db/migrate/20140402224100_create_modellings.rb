class CreateModellings < ActiveRecord::Migration
  def change
    create_table :modellings do |t|

      t.timestamps
    end
  end
end
