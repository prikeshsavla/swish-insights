class Users::SwishController < Users::BaseController
  before_action :set_swish, only: [:show]

  def index
    @swishes = Swish.all.where(user: current_user).reverse
  end

  def show
    if params['toggle'].present?
      if params['toggle'] == 'true'
        @swish.allow_pwa = true
      else
        @swish.allow_pwa = false
      end
      @swish.save
    end


    @swish_reports = @swish.swish_reports.order(created_at: :desc).group_by(&:url)
    @swish_reports_description = {}
    @swish_reports.each do |url, report|
      @swish_reports_description[url] = SwishReport.describe(report)
    end
  end

  def create
    report = ::Services::SwishReport::SaveReport.new.call(params[:swish], current_user.id)
    render json: {"value": report.swish_score}, status: 200
  end

  private

  def set_swish
    @swish = Swish.find(params[:id])
  end

  attr_accessor :swish
end