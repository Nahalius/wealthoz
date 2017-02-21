class RemoveGroupIdFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :group_id, :integer
  end
end
