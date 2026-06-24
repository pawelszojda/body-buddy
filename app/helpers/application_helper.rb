module ApplicationHelper
  def measurement_entries_count_label(count)
    "#{count} #{polish_plural(count, "wpis", "wpisy", "wpisów")}"
  end

  def measurement_entry_timestamp(timestamp)
    timestamp.strftime("%d.%m.%Y • %H:%M")
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
