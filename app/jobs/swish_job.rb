class SwishJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(host, user_id)
    uri = URI(host)
    if uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)
      host = uri.host
    elsif uri.kind_of?(URI::Generic)
      host = uri.to_s
    end
    swish = Swish.where(user_id: user_id, url: host).last
    if swish.present?
      ::Services::Swish::InitiateSwishReportGenerations.new.call(swish.id)
    end

  end
end
