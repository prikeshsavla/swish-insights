class Services::SwishReport::SaveReport

  def call(swish_params, user_id)
    original_url = URI(swish_params[:url])
    host = original_url.host.gsub('www.', '')
    original_url.host = host
    original_url.scheme = 'https'
    swish = Swish.find_or_initialize_by(url: original_url.host, user_id: user_id)

    if swish.new_record?
      swish.user_id = user_id
      swish.save!
    end
    report = swish.swish_reports.build
    data = swish_params[:report]
    filename = host.to_s + '.lighthouse.report.json'
    gist = Gist.gist data, access_token: ENV['GITHUB_TOKEN'], filename: filename
    report.url = original_url.to_s
    report.gist_id = gist['id']
    report.map_data_to_fields(swish_params[:data])
    report.save!
    report
  end

end