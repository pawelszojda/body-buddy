class MeasurementEntriesController < ApplicationController
  def new
    @measurement_entry = current_user.measurement_entries.new
  end

  def create
    @measurement_entry = current_user.measurement_entries.new(measurement_entry_params)

    if @measurement_entry.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Pomiar został dodany." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def measurement_entry_params
    params.require(:measurement_entry).permit(
      :weight,
      :body_fat,
      :mood,
      :sleep_quality,
      :bristol_stool_type,
      :stool_color,
      :note,
      :photo_front,
      :photo_back,
      :photo_side
    )
  end
end
