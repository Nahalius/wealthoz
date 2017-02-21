class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.integer :account_id
      t.integer :group_id
      t.date :budget_date
      t.decimal :ammount
      t.string :text
      t.string :wunit

      t.timestamps
    end
    add_index :budgets, [:account_id, :wunit, :budget_date]
  end
end
