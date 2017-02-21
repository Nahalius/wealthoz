class AddTopicToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :topic, :string
  end
end
