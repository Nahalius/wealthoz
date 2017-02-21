class AddWunitToLedgers < ActiveRecord::Migration
  def change
    add_column :ledgers, :wunit, :string
  end
  
end
