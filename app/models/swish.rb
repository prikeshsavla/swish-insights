class Swish < ApplicationRecord
  include LeaderboardFactory
  belongs_to :user
  acts_as_sequenced scope: :user_id
  has_many :swish_reports, dependent: :destroy

  collection_leaderboard 'score_board'
  before_create :set_allow_pwa

  def set_allow_pwa
    self.allow_pwa = user.allow_pwa
  end

  def set_score_board
    top_swish_reports = SwishReport.where(swish: Swish.where(url: url)).order(swish_score: :desc).group_by(&:url).map { |_k, v| v.first }
    link_count = top_swish_reports.count
    score = (top_swish_reports.sum(&:swish_score) / link_count).round(3)
    board_data = {}
    board_data['host'] = url
    Swish.score_board.rank_member(url, score, board_data)
  end

end
