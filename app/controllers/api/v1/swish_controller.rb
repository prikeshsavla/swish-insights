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

    job = SwishJob.perform_later(host, user_id)
    if job
      render json: {id: job.job_id, host: host}, status: :ok
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