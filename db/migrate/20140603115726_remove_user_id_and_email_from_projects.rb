class RemoveUserIdAndEmailFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :user_id, :integer
    remove_column :projects, :email, :string
  end
end
