module ApplicationHelper
  def app_nav_items
    [
      {
        label: "Panel",
        path: root_path,
        active: current_page?(root_path),
        icon: "home"
      },
      {
        label: "Raport",
        path: report_path,
        active: current_page?(report_path),
        icon: "chart"
      }
    ]
  end

  def mobile_account_nav_item
    if user_signed_in?
      {
        label: "Konto",
        path: session_path,
        active: false,
        icon: "person",
        method: :delete
      }
    else
      {
        label: "Zaloguj",
        path: new_session_path,
        active: current_page?(new_session_path),
        icon: "person"
      }
    end
  end

  def nav_item_classes(active)
    base = "inline-flex items-center rounded-full px-4 py-2 text-sm font-medium transition-all duration-200 ease-out"
    active_classes = "bg-[#1d1d1f] text-white shadow-[0_6px_18px_rgba(29,29,31,0.12)]"
    inactive_classes = "text-[#6e6e73] hover:bg-black/[0.04] hover:text-[#1d1d1f]"

    [ base, active ? active_classes : inactive_classes ].join(" ")
  end

  def mobile_tab_item_classes(active)
    base = "flex min-w-0 flex-1 flex-col items-center justify-center gap-1 rounded-2xl px-3 py-2 text-[11px] font-medium transition-all duration-200 ease-out"
    active_classes = "bg-[#007aff]/10 text-[#007aff]"
    inactive_classes = "text-[#8e8e93] hover:bg-black/[0.03] hover:text-[#1d1d1f]"

    [ base, active ? active_classes : inactive_classes ].join(" ")
  end

  def app_icon(name, active: false)
    classes = active ? "text-[#007aff]" : "text-current"

    case name
    when "home"
      tag.svg xmlns: "http://www.w3.org/2000/svg", fill: active ? "currentColor" : "none", viewBox: "0 0 24 24", stroke: "currentColor", class: "h-5 w-5 #{classes}" do
        tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "1.8", d: "M3 10.75 12 3l9 7.75M5.25 9.5v10.25a1 1 0 0 0 1 1h3.75v-6h4.5v6H18a1 1 0 0 0 1-1V9.5"
      end
    when "chart"
      tag.svg xmlns: "http://www.w3.org/2000/svg", fill: active ? "currentColor" : "none", viewBox: "0 0 24 24", stroke: "currentColor", class: "h-5 w-5 #{classes}" do
        tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "1.8", d: "M4.75 19.25h14.5M7.25 16V9.75m4.75 6.25v-8.5m4.75 8.5v-3.75"
      end
    when "person"
      tag.svg xmlns: "http://www.w3.org/2000/svg", fill: active ? "currentColor" : "none", viewBox: "0 0 24 24", stroke: "currentColor", class: "h-5 w-5 #{classes}" do
        tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "1.8", d: "M15.25 7.5a3.25 3.25 0 1 1-6.5 0 3.25 3.25 0 0 1 6.5 0ZM5.75 19.25c.62-3 2.9-4.75 6.25-4.75s5.63 1.75 6.25 4.75"
      end
    end
  end

  def measurement_entries_count_label(count)
    "#{count} #{polish_plural(count, "wpis", "wpisy", "wpisów")}"
  end

  def measurement_entry_timestamp(timestamp)
    timestamp.strftime("%d.%m.%Y • %H:%M")
  end

  def dashboard_date_label(date = Date.current)
    weekdays = %w[niedziela poniedziałek wtorek środa czwartek piątek sobota]
    months = [
      nil, "stycznia", "lutego", "marca", "kwietnia", "maja", "czerwca",
      "lipca", "sierpnia", "września", "października", "listopada", "grudnia"
    ]

    "#{weekdays[date.wday].capitalize}, #{date.day} #{months[date.month]}"
  end

  def dashboard_metric_delta_pill(delta, unit)
    return "Brak wcześniejszego porównania" if delta.blank?
    return "Bez zmian od poprzedniego wpisu" if delta.zero?

    prefix = delta.negative? ? "" : "+"
    "#{prefix}#{number_with_precision(delta, precision: 2, strip_insignificant_zeros: true)} #{unit} od poprzedniego wpisu"
  end

  def dashboard_metric_delta_classes(delta)
    return "bg-[#f2f2f7] text-[#86868b]" if delta.blank? || delta.zero?

    delta.negative? ? "bg-emerald-50 text-emerald-600" : "bg-[#f2f2f7] text-[#6e6e73]"
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
    return "text-[#86868b]" if delta.blank? || delta.zero?

    improved = comparison_metric_improved?(row)
    improved ? "text-emerald-600" : "text-[#3a3a3c]"
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

  def report_date_range_label(date_from, date_to)
    "#{date_from.strftime("%d.%m.%Y")} - #{date_to.strftime("%d.%m.%Y")}"
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
