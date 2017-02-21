class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :email
      t.integer :user_id
      t.integer :group_id
      t.integer :percent_owned

      t.timestamps
    end
     add_index :projects, [:name, :group_id]
  end
end
