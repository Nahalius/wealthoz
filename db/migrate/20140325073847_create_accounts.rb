class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :group_id
      t.integer :report_id

      t.timestamps
    end
    add_index :accounts, [:name]
  end
end
