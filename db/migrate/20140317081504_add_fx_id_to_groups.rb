class AddFxIdToGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :fx
    add_column :groups, :fx_id, :integer
    
  end
end
