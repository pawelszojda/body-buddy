require "test_helper"

class MicroInteractionsTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "motion@example.com", password: "password123", password_confirmation: "password123")
  end

  test "forms expose loading states and turbo stream prepends animated entries" do
    sign_in_as(@user)

    get new_measurement_entry_path
    assert_response :success
    assert_match "Zapisywanie...", response.body
    assert_match "turbo-subtle-busy", response.body

    get report_path
    assert_response :success
    assert_match "Ładowanie...", response.body

    post measurement_entries_path,
         params: { measurement_entry: { weight: "80.5" } },
         as: :turbo_stream

    assert_response :success
    assert_match "animate-card-in", response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end
