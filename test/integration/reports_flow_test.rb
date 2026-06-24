require "test_helper"

class ReportsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "reports@example.com", password: "password123", password_confirmation: "password123")

    @first_entry = @user.measurement_entries.create!(
      weight: 90.0,
      body_fat: 24.0,
      waist: 98.0,
      abdomen: 101.0,
      created_at: Time.zone.local(2026, 5, 1, 8, 0, 0)
    )

    @middle_entry = @user.measurement_entries.create!(
      weight: 87.2,
      body_fat: 22.5,
      waist: 94.0,
      abdomen: 97.0,
      created_at: Time.zone.local(2026, 5, 14, 8, 0, 0)
    )

    @last_entry = @user.measurement_entries.create!(
      weight: 84.5,
      body_fat: 20.1,
      waist: 90.0,
      abdomen: 94.0,
      created_at: Time.zone.local(2026, 5, 31, 8, 0, 0)
    )
  end

  test "shows comparison report for the selected range" do
    sign_in_as(@user)

    get report_path, params: { date_from: "2026-05-01", date_to: "2026-05-31" }

    assert_response :success
    assert_match "Porównanie metryk", response.body
    assert_match "90 kg", response.body
    assert_match "84.5 kg", response.body
    assert_match "-5.5 kg", response.body
    assert_match "Zdjęcia: pierwszy vs ostatni", response.body
  end

  test "returns turbo frame results for a narrowed date range" do
    sign_in_as(@user)

    get report_path,
        params: { date_from: "2026-05-10", date_to: "2026-05-31" },
        headers: { "Turbo-Frame" => "report_results" }

    assert_response :success
    assert_match "87.2 kg", response.body
    assert_match "84.5 kg", response.body
    assert_no_match "90 kg", response.body
  end

  test "shows empty state when no entries exist in range" do
    sign_in_as(@user)

    get report_path, params: { date_from: "2026-04-01", date_to: "2026-04-30" }

    assert_response :success
    assert_match "Brak pomiarów w zakresie", response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end
