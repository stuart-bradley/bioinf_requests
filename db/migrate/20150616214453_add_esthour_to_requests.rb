class AddEsthourToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :esthours, :integer
  end
end
