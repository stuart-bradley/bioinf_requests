class AddRequestIdColumnToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :request_id, :integer
  end
end
