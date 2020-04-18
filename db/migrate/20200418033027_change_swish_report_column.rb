class ChangeSwishReportColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :swish_reports, :data
    add_column :swish_reports, :gist_id, :string
    add_column :swish_reports, :url, :string
  end
end
