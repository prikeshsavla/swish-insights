class Users::SwishController < Users::BaseController
  def index
    @swishes = Swish.all.where(user: current_user)
  end

  def new

  end

  def create
    swish = Swish.new(url: params[:swish][:url])
    swish.user = current_user
    swish.data = params[:swish][:data]
    params[:swish][:categories].each do |category|
      swish.swish_categories.build(category: Category.find_by_value(category))
    end
    swish.save!
    print params[:swish][:url]
    print swish.url
    print swish

    render json: {"value": 2}, status: 200
  end


end