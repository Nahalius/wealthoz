class AddGroupIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :group_id, :integer
  end
end
