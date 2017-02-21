class DropTransactionTable < ActiveRecord::Migration
  def change
    drop_table :transactions  
  end
  
  def change
  remove_column :ledgers, :transaction_id, :integer
  end
  
end
