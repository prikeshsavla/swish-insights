class Users::SwishController < Users::BaseController
  before_action :set_swish, only: [:show]

  def index
    @swishes = Swish.all.where(user: current_user).reverse
  end

  def show
    @swish_report_description = SwishReport.describe(@swish.swish_reports);
  end

  def create
    uri = URI(params[:swish][:url]).host
    uri = "https://" + uri
    swish = Swish.find_or_initialize_by(url: uri)

    if swish.new_record?
      swish.user = current_user
      swish.save!
    end
    report = swish.swish_reports.build
    data = params[:swish][:report]
    g = Gist.gist data, {access_token: "a6a581d38a1a5ecbbb046194e3e89dbe0f098a63", filename: URI(params[:swish][:url]).host + '.lighthouse.report.json'}
    print("--------------")
    print(g['id'])
    print("--------------")
    report.map_data_to_fields(params[:swish][:data])
    report.save!
    render json: {"value": 2}, status: 200
  end

  private

  def set_swish
    @swish = Swish.find(params[:id])
  end

  attr_accessor :swish
end