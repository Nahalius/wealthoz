class AddIndexToWunit < ActiveRecord::Migration
  def change
    add_index :ledgers, :wunit
  end
end
