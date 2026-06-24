require "test_helper"

class AccountFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "account@example.com", username: "konto_test", password: "password123", password_confirmation: "password123")
  end

  test "shows account page instead of logging out from account route" do
    sign_in_as(@user)

    get account_path

    assert_response :success
    assert_match "Zarządzaj podstawowymi informacjami", response.body
    assert_match @user.username, response.body
  end

  test "updates basic account information" do
    sign_in_as(@user)

    patch account_path, params: { user: { username: "nowy_login", email: "new@example.com" } }

    assert_redirected_to account_path
    @user.reload
    assert_equal "nowy_login", @user.username
    assert_equal "new@example.com", @user.email
  end

  test "updates password when current password is valid" do
    sign_in_as(@user)

    patch account_path, params: {
      user: {
        username: @user.username,
        email: @user.email,
        current_password: "password123",
        password: "new-password-123",
        password_confirmation: "new-password-123"
      }
    }

    assert_redirected_to account_path
    @user.reload
    assert @user.authenticate("new-password-123")
  end

  test "rejects password change with invalid current password" do
    sign_in_as(@user)

    patch account_path, params: {
      user: {
        username: @user.username,
        email: @user.email,
        current_password: "wrong-password",
        password: "new-password-123",
        password_confirmation: "new-password-123"
      }
    }

    assert_response :unprocessable_entity
    assert_match "Aktualne hasło jest nieprawidłowe.", response.body
  end

  test "deletes account" do
    sign_in_as(@user)

    assert_difference("User.count", -1) do
      delete account_path
    end

    assert_redirected_to new_session_path
  end

  private

  def sign_in_as(user)
    post session_path, params: { login: user.email, password: "password123" }
  end
end
