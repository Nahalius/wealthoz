class FixUserIdToLedger < ActiveRecord::Migration
  def change
    rename_column :ledgers, :wunit_id, :user_id
  end
end
