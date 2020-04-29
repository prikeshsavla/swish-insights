class HomeController < ApplicationController
  layout 'shared/layouts/application'
  def index
  end

  def leaderboards
    @swish_score_board = SwishReport.swish_score_board.top(10)
  end
end
