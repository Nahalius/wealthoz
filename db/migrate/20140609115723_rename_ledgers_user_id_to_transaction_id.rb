class RenameLedgersUserIdToTransactionId < ActiveRecord::Migration
  def change
     rename_column :ledgers, :user_id, :transaction_id
  end
end
