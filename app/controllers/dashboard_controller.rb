class DashboardController < ApplicationController
  def index
    @measurement_entries = current_user.measurement_entries.recent_first
    @latest_entry = @measurement_entries.first
    @previous_entry = @measurement_entries.second
  end
end
