require "test_helper"

class MeasurementEntryFormStylingTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "form-style@example.com", password: "password123", password_confirmation: "password123")
  end

  test "quick add form renders sectioned ios style layout" do
    sign_in_as(@user)

    @user.measurement_entries.create!(
      weight: 82.4,
      body_fat: 21.5,
      calf: 40.0,
      thigh: 59.0,
      buttocks: 101.0,
      waist: 86.0,
      abdomen: 90.0,
      chest: 104.0,
      biceps: 35.0,
      forearm: 28.0
    )

    get new_measurement_entry_path

    assert_response :success
    assert_match "Podstawowe pomiary", response.body
    assert_match "Obwody ciała", response.body
    assert_match "Samopoczucie i zdrowie", response.body
    assert_match "Zdjęcia progresu", response.body
    assert_match "upload-preview", response.body
    assert_match "Twardy, zbity", response.body
    assert_match "value=\"82.4\"", response.body
    assert_match "value=\"21.5\"", response.body
    assert_match "Porzuć", response.body
    assert_match "Aparat", response.body
    assert_match "Biblioteka", response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { login: user.email, password: "password123" }
  end
end
