class ReportsController < ApplicationController
  def show
    @date_from, @date_to = resolved_date_range
    @entries_in_range = current_user.measurement_entries.within_date_range(@date_from, @date_to)
    @first_entry = @entries_in_range.chronological.first
    @last_entry = @entries_in_range.chronological.last

    if turbo_frame_request?
      render partial: "reports/results",
             locals: {
               first_entry: @first_entry,
               last_entry: @last_entry,
               date_from: @date_from,
               date_to: @date_to
             }
    end
  end

  private

  def resolved_date_range
    oldest_entry_at = current_user.measurement_entries.minimum(:created_at)
    default_from = oldest_entry_at&.to_date || Date.current - 30.days
    default_to = Date.current

    date_from = parse_date(params[:date_from]) || default_from
    date_to = parse_date(params[:date_to]) || default_to

    date_from, date_to = [ date_from, date_to ].minmax
    [ date_from, date_to ]
  end

  def parse_date(value)
    return if value.blank?

    Date.iso8601(value)
  rescue ArgumentError
    nil
  end
end
