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

  def group_class(new_value)
    if new_value < 50
      'text-fail'
    elsif new_value < 90
      'text-average'
    else
      'text-pass'
    end
  end

  def metric_with_change(report, metric, reports, index, prefix: '', inverse: false, show_group_color: false)
    last = index == (reports.length - 1)
    new_value = report.send(metric)
    old_value = last ? new_value : reports[index + 1].send(metric)
    [
        "<span class='",
        if show_group_color
          group_class(new_value)
        end,
        "'>",
        new_value,
        "</span>",
        prefix,
        last ? '' : "<br><small ",
        last ? '' : "class='text-#{difference_class(new_value, old_value, inverse)}'>",
        last ? '' : " (#{percentage_difference(new_value, old_value)})</small>"
    ].join
  end

  def diplay_with_group_color(value)
    ["<span class='",
     group_class(value),
     "'>",
     value,
     '</span>'].join
  end

  def leaderboard_rank_class(rank)
    rank <= 3 ? 'table-warning' : (rank <= 10 ? 'table-success' : '')
  end

end
