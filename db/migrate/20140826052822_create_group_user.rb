class CreateGroupUser < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :group
      t.references :user
      t.integer    :status, default: 0
    end
  end
end
