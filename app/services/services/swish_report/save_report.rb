class Services::SwishReport::SaveReport

  def call(params, current_user)
    uri = URI(params[:swish][:url]).host
    uri = 'https://' + uri
    swish = Swish.find_or_initialize_by(url: uri)

    if swish.new_record?
      swish.user = current_user
      swish.save!
    end
    report = swish.swish_reports.build
    data = params[:swish][:report]
    filename = URI(params[:swish][:url]).host + '.lighthouse.report.json'
    gist = Gist.gist data, access_token: ENV['GITHUB_TOKEN'], filename: filename
    report.url = params[:swish][:url]
    report.gist_id = gist['id']
    report.map_data_to_fields(params[:swish][:data])
    report.save!
  end

end