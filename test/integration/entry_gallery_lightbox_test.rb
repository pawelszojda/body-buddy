require "test_helper"

class EntryGalleryLightboxTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "gallery@example.com", username: "gallery_user", password: "password123", password_confirmation: "password123")
    @entry = @user.measurement_entries.create!(
      weight: 79.5,
      created_at: Time.zone.local(2026, 6, 24, 8, 0, 0),
      updated_at: Time.zone.local(2026, 6, 24, 8, 0, 0)
    )
    @entry.photo_front.attach(
      io: File.open(Rails.root.join("public/icon.png"), "rb"),
      filename: "icon.png",
      content_type: "image/png"
    )
  end

  test "entry details render clickable image lightbox markup" do
    sign_in_as(@user)

    get measurement_entry_path(@entry)

    assert_response :success
    assert_match "cursor-zoom-in", response.body
    assert_match "image-lightbox#open", response.body
    assert_match "data-image-lightbox-target=\"dialog\"", response.body
  end

  private

  def sign_in_as(user)
    post session_path, params: { login: user.email, password: "password123" }
  end
end
