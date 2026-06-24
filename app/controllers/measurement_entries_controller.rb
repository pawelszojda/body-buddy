class MeasurementEntriesController < ApplicationController
  def show
    @measurement_entry = current_user.measurement_entries.find(params[:id])
  end

  def new
    @measurement_entry = current_user.measurement_entries.new(prefill_attributes)
    @return_to = safe_return_to
  end

  def create
    @measurement_entry = current_user.measurement_entries.new(measurement_entry_params)
    @return_to = safe_return_to

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
      :calf,
      :thigh,
      :buttocks,
      :waist,
      :abdomen,
      :chest,
      :biceps,
      :forearm,
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

  def prefill_attributes
    MeasurementEntry.prefill_attributes_from(current_user.measurement_entries.recent_first.first)
  end

  def safe_return_to
    return root_path if params[:return_to].blank?

    uri = URI.parse(params[:return_to])
    return root_path if uri.host.present? || uri.scheme.present?

    params[:return_to]
  rescue URI::InvalidURIError
    root_path
  end
end
