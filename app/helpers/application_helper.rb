module ApplicationHelper
  def measurement_entries_count_label(count)
    "#{count} #{polish_plural(count, "wpis", "wpisy", "wpisów")}"
  end

  def measurement_entry_timestamp(timestamp)
    timestamp.strftime("%d.%m.%Y • %H:%M")
  end

  def measurement_metric_value(value, unit)
    return "Brak" if value.blank?

    "#{number_with_precision(value, precision: 2, strip_insignificant_zeros: true)} #{unit}".strip
  end

  def measurement_delta_value(delta, unit)
    return "Brak" if delta.blank?

    formatted_number = number_with_precision(delta.abs, precision: 2, strip_insignificant_zeros: true)
    prefix = delta.positive? ? "+" : delta.negative? ? "-" : "0"

    if delta.zero?
      "0 #{unit}".strip
    else
      "#{prefix}#{formatted_number} #{unit}".strip
    end
  end

  def comparison_delta_classes(row)
    delta = row[:delta]
    return "text-slate-500" if delta.blank? || delta.zero?

    improved = comparison_metric_improved?(row)
    improved ? "text-emerald-600" : "text-rose-600"
  end

  def comparison_metric_improved?(row)
    return false if row[:delta].blank?

    case row[:positive_trend]
    when :decrease
      row[:delta].negative?
    when :increase
      row[:delta].positive?
    else
      false
    end
  end

  private

  def polish_plural(count, singular, paucal, plural)
    return singular if count == 1

    mod10 = count % 10
    mod100 = count % 100

    return paucal if (2..4).cover?(mod10) && !(12..14).cover?(mod100)

    plural
  end
end
