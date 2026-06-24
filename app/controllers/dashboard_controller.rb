class DashboardController < ApplicationController
  def index
    @measurement_entries = current_user.measurement_entries.recent_first
  end
end
