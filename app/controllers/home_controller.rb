class HomeController < ApplicationController
  layout 'shared/layouts/application'

  def index
  end

  def leaderboards
    @swish_score_board = Swish.score_board.top(10)
  end
  def leaderboard_scoring

  end

  def privacy
  end

  def terms
  end
end
