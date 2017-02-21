class AddIndexToTopic < ActiveRecord::Migration
  def change
    add_index :microposts, :topic
  end
end
