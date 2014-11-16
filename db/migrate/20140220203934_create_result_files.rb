class CreateResultFiles < ActiveRecord::Migration
  def change
    create_table :result_files do |t|
      t.integer :request_id
      t.string :attachment_uploader

      t.timestamps
    end
  end
end
