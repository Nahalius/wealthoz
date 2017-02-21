class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|
      t.integer :account_id
      t.integer :wunit_id
      t.date :post_date
      t.decimal :ammount
      t.string :text
      t.decimal :quantity

      t.timestamps
    end
    add_index :ledgers, [:account_id, :wunit_id, :post_date]
  end
end
