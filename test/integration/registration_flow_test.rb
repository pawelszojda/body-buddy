require "test_helper"

class RegistrationFlowTest < ActionDispatch::IntegrationTest
  test "renders sign up page" do
    get new_user_path

    assert_response :success
    assert_match "Załóż konto w Body Buddy", response.body
  end

  test "creates account and signs user in" do
    assert_difference("User.count", 1) do
      post users_path, params: {
        user: {
          username: "nowy_user",
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "Dodaj pomiar", response.body
  end

  test "shows validation errors on invalid sign up" do
    post users_path, params: {
      user: {
        username: "ab",
        email: "",
        password: "password123",
        password_confirmation: "different"
      }
    }

    assert_response :unprocessable_entity
    assert_match "Nie udało się utworzyć konta.", response.body
  end

  test "rejects duplicate username on sign up" do
    User.create!(
      username: "zajety_login",
      email: "existing@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_no_difference("User.count") do
      post users_path, params: {
        user: {
          username: "ZAJETY_LOGIN",
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_match "Username jest już zajęta", response.body
  end
end
