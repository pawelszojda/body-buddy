require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com", username: "test_user", password: "password123", password_confirmation: "password123")
  end

  test "redirects unauthenticated users to login" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "logs in with valid credentials" do
    post session_path, params: { login: @user.email, password: "password123" }

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "Dodaj pomiar", response.body
  end

  test "logs in with username" do
    post session_path, params: { login: @user.username, password: "password123" }

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "Dodaj pomiar", response.body
  end

  test "rejects invalid credentials" do
    post session_path, params: { login: @user.email, password: "wrong-password" }

    assert_response :unprocessable_entity
    assert_match "Nieprawidłowy e-mail lub hasło.", response.body
  end
end
