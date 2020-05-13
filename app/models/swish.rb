class Swish < ApplicationRecord
  include LeaderboardFactory
  belongs_to :user
  acts_as_sequenced scope: :user_id
  has_many :swish_reports, dependent: :destroy

  scope :from_this_month, lambda { where("swishes.created_at > ? AND swishes.created_at < ?", Time.now.beginning_of_month, Time.now.end_of_month) }


  collection_leaderboard 'score_board'
  before_create :set_allow_pwa

  def set_allow_pwa
    self.allow_pwa = user.allow_pwa
  end

  def activity
    self.swish_reports.order(created_at: :asc).group_by { |r| r.created_at.beginning_of_day.to_i }.map { |r, d| {"#{r}": d.count} }.reduce(:merge)
  end

  def set_score_board
    top_swish_reports = SwishReport.where(swish: Swish.where(url: url)).order(swish_score: :desc).group_by(&:url).map { |_k, v| v.first }
    link_count = top_swish_reports.count
    score = (top_swish_reports.sum(&:swish_score) / link_count).round(3)
    self.update_attribute(:score, score)
    board_data = {}
    board_data['host'] = url
    Swish.score_board.rank_member(url, score, board_data)
  end


  def self.rank_all
    Swish.all.each do |swish_report|
      swish_report.set_score_board
    end
  end
end
