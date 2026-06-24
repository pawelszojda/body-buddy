require "test_helper"

class DashboardFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "dashboard@example.com", password: "password123", password_confirmation: "password123")
  end

  test "dashboard renders the quick add shell for authenticated users" do
    sign_in_as(@user)

    get root_path

    assert_response :success
    assert_match "Dodaj pomiar", response.body
    assert_match "Ostatnie pomiary", response.body
  end

  test "creates a measurement entry through turbo stream" do
    sign_in_as(@user)

    assert_difference("MeasurementEntry.count", 1) do
      post measurement_entries_path,
           params: { measurement_entry: { weight: "82.4", mood: "4", sleep_quality: "5" } },
           as: :turbo_stream
    end

    assert_response :success
    assert_equal Mime[:turbo_stream], response.media_type
    assert_match "turbo-stream action=\"prepend\"", response.body
    assert_match "82.4", response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { login: user.email, password: "password123" }
  end
end
