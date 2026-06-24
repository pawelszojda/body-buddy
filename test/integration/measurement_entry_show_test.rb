require "test_helper"

class MeasurementEntryShowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "details@example.com", password: "password123", password_confirmation: "password123")
    @measurement_entry = @user.measurement_entries.create!(
      weight: 81.7,
      body_fat: 19.5,
      calf: 39.5,
      thigh: 58.0,
      waist: 84.0,
      mood: 4,
      sleep_quality: 5,
      bristol_stool_type: 4,
      stool_color: "Brązowy",
      note: "Dobry trening i spokojny dzień."
    )
  end

  test "shows the measurement entry details page" do
    sign_in_as(@user)

    get measurement_entry_path(@measurement_entry)

    assert_response :success
    assert_match "Pełny zestaw pomiarów", response.body
    assert_match "Dobry trening i spokojny dzień.", response.body
    assert_match "Łydka", response.body
    assert_match "Skala Bristol", response.body
    assert_match "Zdjęcia sylwetki", response.body
  end

  test "does not expose entries belonging to another user" do
    other_user = User.create!(email: "other@example.com", password: "password123", password_confirmation: "password123")
    sign_in_as(other_user)

    get measurement_entry_path(@measurement_entry)

    assert_response :not_found
  end

  private

  def sign_in_as(user)
    post session_path, params: { login: user.email, password: "password123" }
  end
end
