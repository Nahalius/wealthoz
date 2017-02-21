class RemoveGroupIdFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :group_id, :integer
  end
end
