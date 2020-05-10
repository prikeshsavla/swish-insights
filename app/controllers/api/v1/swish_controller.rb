class Api::V1::SwishController < ApplicationController
  def generate
    user_id = User.find_by(api_key: request.params["key"]).id
    host = request.params["host"]

    if SwishJob.perform_later(host, user_id)
      render status: :ok
    end
  end
end