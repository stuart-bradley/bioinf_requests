class DropEmployeesTable < ActiveRecord::Migration
  def up
    drop_table :employees
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
