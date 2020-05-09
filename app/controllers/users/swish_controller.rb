class Users::SwishController < Users::BaseController
  before_action :set_swish, only: [:show]

  def index
    @swishes = Swish.all.where(user: current_user).reverse
  end

  def show
    @swish_reports = @swish.swish_reports.order(created_at: :desc).group_by(&:url)
    @swish_reports_description = {}
    @swish_reports.each do |url, report|
      @swish_reports_description[url] = SwishReport.describe(report)
    end
  end

  def create
    ::Services::SwishReport::SaveReport.new.call(params, current_user)
    render json: {"value": 2}, status: 200
  end

  private
  def set_swish
    @swish = Swish.find(params[:id])
  end

  attr_accessor :swish
end