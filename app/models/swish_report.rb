class SwishReport < ApplicationRecord
  include LeaderboardFactory
  belongs_to :swish
  has_one :user, through: :swish

  collection_leaderboard 'swish_score_board'

  before_create :calculate_swish_score
  after_create :set_swish_score_board

  def calculate_swish_score
    self.swish_score = (accessibility + performance + seo + best_practices + (600 - (first_contentful_paint + first_cpu_idle + first_meaningful_paint + estimated_input_latency + time_to_interactive + speed_index))).to_f.round(2)
  end

  def set_swish_score_board
    if join_leaderboard.present? || SwishReport.swish_score_board.member_data_for(url)
      board_data = SwishReport.swish_score_board.member_data_for(url) || to_h
      board_data['host'] = board_data['host'] || URI(url).host
      board_data['url'] = board_data['url'] || url
      board_data['joined'] = board_data['joined'] || join_leaderboard || DateTime.now.to_s

      highscore_check = lambda do |member, current_score, score, member_data, leaderboard_options|
        return true if current_score.nil?
        return true if score > current_score
        false
      end
      SwishReport.swish_score_board.rank_member_if(highscore_check, url, swish_score, board_data)
    end
  end


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

  def self.rank_all
    SwishReport.all.each do |swish_report|
      swish_report.calculate_swish_score
      swish_report.set_swish_score_board
      swish_report.save
    end
  end

  def self.describe(reports)
    reports_array = reports.map(&:to_a)

    df = Daru::DataFrame.new(reports_array);
    df = df.transpose

    df.describe([:count, :mean, :median, :min, :max]).transpose.to_h
  end
end
