class CreateFxes < ActiveRecord::Migration
  def change
    create_table :fxes do |t|
      t.string :country
      t.string :fx
      t.decimal :usd_to
      t.decimal :to_usd

      t.timestamps
    end
    add_index :fxes, [:fx]
  end
end
