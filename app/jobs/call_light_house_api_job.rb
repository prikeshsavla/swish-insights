class CallLightHouseApiJob < ApplicationJob
  queue_as :default

  def perform(query_url, user_id)

    categories = ["accessibility",
                  "best-practices",
                  "performance",
                  "pwa",
                  "seo"]
    escaped_query_url = CGI.escape(query_url)

    base_url = "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?key=#{ENV['LIGHTHOUSE_API_KEY']}&url=#{escaped_query_url}"
    categories_param_string = categories.map { |category| "&category=#{category}" }.join

    api_url = [base_url, categories_param_string].join

    print(api_url);

    response = ::HTTParty.get(api_url)

    report = response.body
    body = JSON.parse(response.body) # e.g {answer: 'because it was there'}

    lighthouse = body["lighthouseResult"]

    lighthouse_metrics = {
        "Performance": lighthouse["categories"]["performance"] ? lighthouse["categories"]["performance"]["score"] * 100 : null,
        "Accessibility": lighthouse["categories"]["accessibility"] ? lighthouse["categories"]["accessibility"]["score"] * 100 : null,
        "Best-Practices": lighthouse["categories"]["best-practices"] ? lighthouse["categories"]["best-practices"]["score"] * 100 : null,
        "PWA": lighthouse["categories"]["pwa"] ? lighthouse["categories"]["pwa"]["score"] * 100 : null,
        "SEO": lighthouse["categories"]["seo"] ? lighthouse["categories"]["seo"]["score"] * 100 : null,
        "First Contentful Paint": lighthouse["audits"]["first-contentful-paint"]["displayValue"],
        "Speed Index": lighthouse["audits"]["speed-index"]["displayValue"],
        "Time To Interactive": lighthouse["audits"]["interactive"]["displayValue"],
        "First Meaningful Paint": lighthouse["audits"]["first-meaningful-paint"]["displayValue"],
        "First CPU Idle": lighthouse["audits"]["first-cpu-idle"]["displayValue"],
        "Estimated Input Latency": lighthouse["audits"]["estimated-input-latency"]["displayValue"]
    }
    print(lighthouse_metrics)
    body
    params = {
        "url": query_url,
        "report": lighthouse.to_json,
        "data": OpenStruct.new(lighthouse_metrics)
    }
    print(params)
    ::Services::SwishReport::SaveReport.new.call(params, user_id)
  end
end
