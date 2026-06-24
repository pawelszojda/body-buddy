require "test_helper"

class PwaMobilePolishTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "pwa@example.com", password: "password123", password_confirmation: "password123")
  end

  test "application layout exposes pwa and turbo mobile meta tags" do
    sign_in_as(@user)

    get root_path

    assert_response :success
    assert_match 'content="width=device-width,initial-scale=1,viewport-fit=cover"', response.body
    assert_match 'name="apple-mobile-web-app-status-bar-style" content="default"', response.body
    assert_match 'name="turbo-refresh-method" content="morph"', response.body
    assert_match 'name="turbo-refresh-scroll" content="preserve"', response.body
    assert_match 'rel="manifest"', response.body
    assert_match 'data-turbo-preload="true"', response.body
  end

  test "manifest is exposed for installable pwa setup" do
    get pwa_manifest_path(format: :json)

    assert_response :success
    assert_match /"display":\s*"standalone"/, response.body
    assert_match /"orientation":\s*"portrait"/, response.body
    assert_match /"background_color":\s*"#f5f5f7"/, response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { login: user.email, password: "password123" }
  end
end
