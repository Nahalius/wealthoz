class CreateFs < ActiveRecord::Migration
  def change
    create_table :fs do |t|
      t.string :report
      t.string :report_class

      t.timestamps
    end
    add_index :fs, [:report, :report_class]
  end
end
