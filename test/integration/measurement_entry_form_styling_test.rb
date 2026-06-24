require "test_helper"

class MeasurementEntryFormStylingTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "form-style@example.com", password: "password123", password_confirmation: "password123")
  end

  test "quick add form renders sectioned ios style layout" do
    sign_in_as(@user)

    get new_measurement_entry_path

    assert_response :success
    assert_match "Podstawowe pomiary", response.body
    assert_match "Obwody ciała", response.body
    assert_match "Samopoczucie i zdrowie", response.body
    assert_match "Zdjęcia progresu", response.body
    assert_match "upload-preview", response.body
    assert_match "Twardy, zbity", response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end
