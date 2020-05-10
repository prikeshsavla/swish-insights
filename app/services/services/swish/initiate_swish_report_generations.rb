class Services::Swish::InitiateSwishReportGenerations

  def call(swish_id)
    swish = Swish.find(swish_id)
    swish_urls = swish.swish_reports.pluck(:url).uniq
    swish_urls.each do |url|
      CallLightHouseApiJob.perform_later(url, swish.user_id)
    end
  end
end