class DashboardController < ApplicationController
  def index
    entries = current_user.measurement_entries
    @latest_entry = entries.recent_first.first
    @previous_entry = entries.recent_first.offset(1).first
    @date_from = parse_date(params[:date_from])
    @date_to = parse_date(params[:date_to])

    filtered_entries = entries
    filtered_entries = filtered_entries.where(created_at: @date_from.beginning_of_day..) if @date_from
    filtered_entries = filtered_entries.where(created_at: ..@date_to.end_of_day) if @date_to

    @filtered_entries_count = filtered_entries.count
    @measurement_entries = filtered_entries.recent_first.limit(10)
  end

  private

  def parse_date(value)
    return if value.blank?

    Date.iso8601(value)
  rescue ArgumentError
    nil
  end
end
