require "test_helper"

class StylingShellTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "styling@example.com", password: "password123", password_confirmation: "password123")
  end

  test "application shell renders mobile tab bar and desktop navigation" do
    sign_in_as(@user)

    get root_path

    assert_response :success
    assert_match "Panel", response.body
    assert_match "Raport", response.body
    assert_match "Konto", response.body
    assert_match "md:hidden", response.body
    assert_match "backdrop-blur-md", response.body
    assert_match "scroll-smooth", response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { login: user.email, password: "password123" }
  end
end
