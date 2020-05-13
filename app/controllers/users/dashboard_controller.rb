class Users::DashboardController < Users::BaseController

  def index
    last_swish_report = current_user.swish_reports.order(created_at: :desc).first
    user = current_user


    @data = OpenStruct.new({
                               total_swishes: user.swishes.count,
                               total_swishes_this_month: user.swishes.count,
                               total_swish_reports: user.swish_reports.from_this_month.count,
                               total_swish_reports_this_month: user.swish_reports.from_this_month.count,
                               top_score_swish: user.swishes.order(score: :desc).first,
                               lowest_score_swish: user.swishes.order(score: :asc).first,
                           })

  end

  attr_accessor :data
end