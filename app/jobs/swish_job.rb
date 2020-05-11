class SwishJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0

  def perform(host, user_id)
    swish = Swish.where(user_id: user_id, url: host).last
    if swish.present?
      ::Services::Swish::InitiateSwishReportGenerations.new.call(swish.id)
    end

  end
end
