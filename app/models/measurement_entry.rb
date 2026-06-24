class MeasurementEntry < ApplicationRecord
  BODY_MEASUREMENT_FIELDS = %i[calf thigh buttocks waist abdomen chest biceps forearm].freeze
  MOOD_EMOJIS = {
    1 => "😞",
    2 => "😐",
    3 => "🙂",
    4 => "😄",
    5 => "🤩"
  }.freeze
  SLEEP_EMOJIS = {
    1 => "😴",
    2 => "🥱",
    3 => "🙂",
    4 => "🌙",
    5 => "✨"
  }.freeze
  BRISTOL_LABELS = {
    1 => "Typ 1",
    2 => "Typ 2",
    3 => "Typ 3",
    4 => "Typ 4",
    5 => "Typ 5",
    6 => "Typ 6",
    7 => "Typ 7"
  }.freeze

  belongs_to :user

  has_one_attached :photo_front
  has_one_attached :photo_back
  has_one_attached :photo_side

  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :body_fat, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates(*BODY_MEASUREMENT_FIELDS, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true)
  validates :mood, inclusion: { in: 1..5 }, allow_nil: true
  validates :sleep_quality, inclusion: { in: 1..5 }, allow_nil: true
  validates :bristol_stool_type, inclusion: { in: 1..7 }, allow_nil: true

  scope :recent_first, -> { order(created_at: :desc) }

  def quick_status_badges
    [
      mood_badge,
      sleep_badge,
      bristol_badge
    ].compact
  end

  def mood_badge
    return if mood.blank?

    { label: "Nastrój", value: "#{MOOD_EMOJIS[mood]} #{mood}/5" }
  end

  def sleep_badge
    return if sleep_quality.blank?

    { label: "Sen", value: "#{SLEEP_EMOJIS[sleep_quality]} #{sleep_quality}/5" }
  end

  def bristol_badge
    return if bristol_stool_type.blank?

    { label: "Bristol", value: BRISTOL_LABELS[bristol_stool_type] }
  end
end
