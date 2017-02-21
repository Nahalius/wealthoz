class RanameProjectidToGroupid < ActiveRecord::Migration
  def change
    rename_column :projects, :project_id, :group_id
  end
end
