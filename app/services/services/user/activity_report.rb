class Services::User::ActivityReport
  def call(user)
    user.swish_reports.where(created_at: DateTime.now.beginning_of_year..DateTime.now.end_of_year).order(created_at: :asc).group_by do |report|
      report.created_at.beginning_of_day.to_i
    end.map { |report, day| {"#{report}": day.count} }.reduce(:merge)
  end
end