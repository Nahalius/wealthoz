class AddIndexToDefaultAccounts < ActiveRecord::Migration
  def change
    add_index :accounts, :default 
  end
end
