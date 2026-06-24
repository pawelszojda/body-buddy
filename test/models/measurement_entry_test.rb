require "test_helper"

class MeasurementEntryTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "measurements@example.com", password: "password123", password_confirmation: "password123")
  end

  test "is valid with the required attributes only" do
    entry = MeasurementEntry.new(user: @user, weight: 82.4)

    assert entry.valid?
  end

  test "requires a positive weight" do
    entry = MeasurementEntry.new(user: @user, weight: 0)

    assert_not entry.valid?
    assert_includes entry.errors[:weight], "must be greater than 0"
  end

  test "rejects negative body measurements" do
    entry = MeasurementEntry.new(user: @user, weight: 82.4, waist: -1)

    assert_not entry.valid?
    assert_includes entry.errors[:waist], "must be greater than or equal to 0"
  end

  test "rejects body fat values above 100" do
    entry = MeasurementEntry.new(user: @user, weight: 82.4, body_fat: 101)

    assert_not entry.valid?
    assert_includes entry.errors[:body_fat], "must be less than or equal to 100"
  end

  test "rejects mood outside the supported range" do
    entry = MeasurementEntry.new(user: @user, weight: 82.4, mood: 6)

    assert_not entry.valid?
    assert_includes entry.errors[:mood], "is not included in the list"
  end

  test "allows optional photo attachments" do
    entry = MeasurementEntry.new(user: @user, weight: 82.4)

    assert entry.valid?
    assert_not entry.photo_front.attached?
    assert_not entry.photo_back.attached?
    assert_not entry.photo_side.attached?
  end
end
