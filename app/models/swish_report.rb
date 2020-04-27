class SwishReport < ApplicationRecord
  has_one :swish

  def map_data_to_fields(data)
    self.accessibility ||= data['Accessibility'].to_f
    self.performance ||= data['Performance'].to_f
    self.pwa ||= data['PWA'].to_f
    self.seo ||= data['SEO'].to_f
    self.best_practices ||= data['Best-Practices'].to_f
    self.first_contentful_paint ||= data['First Contentful Paint']
    self.first_cpu_idle ||= data['First CPU Idle']
    self.first_meaningful_paint ||= data['First Meaningful Paint']
    self.estimated_input_latency ||= data['Estimated Input Latency']
    self.time_to_interactive ||= data['Time To Interactive']
    self.speed_index ||= data['Speed Index']
  end

  # Exclude password info from json output.
  def to_json(options = {})
    options[:except] ||= [:report, :id]
    super(options)
  end

  def to_h
    {
        "accessibility": self.accessibility,
        "performance": self.performance,
        "pwa": self.pwa,
        "seo": self.seo,
        "best_practices": self.best_practices,
        "first_contentful_paint": self.first_contentful_paint,
        "first_cpu_idle": self.first_cpu_idle,
        "first_meaningful_paint": self.first_meaningful_paint,
        "estimated_input_latency": self.estimated_input_latency,
        "time_to_interactive": self.time_to_interactive,
        "speed_index": self.speed_index
    }
  end

  def to_a
    [
        self.accessibility,
        self.performance,
        self.pwa,
        self.seo,
        self.best_practices,
        self.first_contentful_paint,
        self.first_cpu_idle,
        self.first_meaningful_paint,
        self.estimated_input_latency,
        self.time_to_interactive,
        self.speed_index
    ]
  end

  def self.describe(reports)
    reports_array = reports.map(&:to_a)

    df = Daru::DataFrame.new(reports_array);
    df = df.transpose

    df.describe([:count, :mean,:median, :min, :max]).transpose.to_h
  end
end
