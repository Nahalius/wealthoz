class RenameUserIdToGroupIdInLedgers < ActiveRecord::Migration
  def change
    rename_column :ledgers, :user_id, :group_id
  end
end
