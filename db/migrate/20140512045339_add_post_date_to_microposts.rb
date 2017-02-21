class AddPostDateToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :post_date, :date
  end
 end
