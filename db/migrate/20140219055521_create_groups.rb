class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :fx

      t.timestamps
    end
    add_index :groups, [:name]
  end
end
