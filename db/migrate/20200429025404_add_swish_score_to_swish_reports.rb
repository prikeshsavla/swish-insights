class AddSwishScoreToSwishReports < ActiveRecord::Migration[6.0]
  def change
    add_column :swish_reports, :swish_score, :float
    add_column :swish_reports, :join_leaderboard, :datetime
  end
end
