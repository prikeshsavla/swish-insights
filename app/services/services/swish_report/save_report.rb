class Services::SwishReport::SaveReport

  def call(params, current_user)
    original_url = URI(params[:swish][:url])
    host = original_url.host.gsub('www.', '')
    original_url.host = host
    original_url.scheme = 'https'
    swish = Swish.find_or_initialize_by(url: original_url.host, user: current_user)

    if swish.new_record?
      swish.user = current_user
      swish.save!
    end
    report = swish.swish_reports.build
    data = params[:swish][:report]
    filename = host.to_s + '.lighthouse.report.json'
    gist = Gist.gist data, access_token: ENV['GITHUB_TOKEN'], filename: filename
    report.url = original_url.to_s
    report.gist_id = gist['id']
    report.map_data_to_fields(params[:swish][:data])
    report.save!
  end

end