class AddResultToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :result, :text
  end
end
