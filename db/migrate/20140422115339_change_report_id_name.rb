class ChangeReportIdName < ActiveRecord::Migration
  def change
    rename_column :accounts, :report_id, :fs_id
  end
end
