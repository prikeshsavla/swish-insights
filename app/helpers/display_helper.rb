module DisplayHelper
  def percentage_difference(new_value, previous_value)
    (((new_value.to_f - previous_value.to_f) / previous_value.to_f) * 100.0).round(2)
  end

  def difference_class(new_value, previous_value, inverse = false)
    difference = (new_value - previous_value)

    if difference.zero?
      return 'muted'
    end
    if inverse
      if (new_value - previous_value).negative?
        'success'
      else
        'danger'
      end
    else
      if (new_value - previous_value).negative?
        'danger'
      else
        'success'
      end
    end

  end

  def metric_with_change(report, metric, reports, index, prefix = '', inverse = false)
    last = index == (reports.length - 1)
    new_value = report.send(metric)
    old_value = last ? new_value : reports[index + 1].send(metric)
    [
        new_value,
        prefix,
        last ? '' : "<br><small ",
        last ? '' : "class='text-#{difference_class(new_value, old_value, inverse)}'>",
        last ? '' : " (#{percentage_difference(new_value, old_value)})</small>"
    ].join
  end

end
