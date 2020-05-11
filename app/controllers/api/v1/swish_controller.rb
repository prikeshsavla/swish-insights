class Api::V1::SwishController < ApplicationController
  NotAuthorized = Class.new(StandardError)
  MissingParameters = Class.new(StandardError)
  before_action :validate_api_key

  def generate
    user_id = User.find_by(api_key: request.params["key"]).id
    host = request.params["host"]
    if host.nil?
      raise MissingParameters('You need to send a host to start the request')
    end
    uri = URI(host)
    if uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)
      host = uri.host
    elsif uri.kind_of?(URI::Generic)
      host = uri.to_s
    end
    if SwishJob.perform_later(host, user_id)
      render json: {}, status: :ok
    end
  end


  private

  def validate_api_key
    print(request.params["key"])
    print(User.where(api_key: request.params["key"]).count)
    if User.where(api_key: request.params["key"]).count == 0
      raise NotAuthorized
    end
  end


end