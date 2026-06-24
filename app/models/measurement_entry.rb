class MeasurementEntry < ApplicationRecord
  BODY_MEASUREMENT_FIELDS = %i[calf thigh buttocks waist abdomen chest biceps forearm].freeze
  PREFILL_FIELDS = [ :weight, :body_fat, *BODY_MEASUREMENT_FIELDS ].freeze
  COMPARISON_FIELDS = [
    { field: :weight, label: "Waga", unit: "kg", positive_trend: :decrease },
    { field: :body_fat, label: "Tkanka tłuszczowa", unit: "%", positive_trend: :decrease },
    { field: :calf, label: "Łydka", unit: "cm", positive_trend: :decrease },
    { field: :thigh, label: "Udo", unit: "cm", positive_trend: :decrease },
    { field: :buttocks, label: "Pośladki", unit: "cm", positive_trend: :decrease },
    { field: :waist, label: "Pas", unit: "cm", positive_trend: :decrease },
    { field: :abdomen, label: "Brzuch", unit: "cm", positive_trend: :decrease },
    { field: :chest, label: "Klatka piersiowa", unit: "cm", positive_trend: :decrease },
    { field: :biceps, label: "Biceps", unit: "cm", positive_trend: :decrease },
    { field: :forearm, label: "Przedramię", unit: "cm", positive_trend: :decrease }
  ].freeze
  BODY_MEASUREMENT_LABELS = {
    calf: "Łydka",
    thigh: "Udo",
    buttocks: "Pośladki",
    waist: "Pas",
    abdomen: "Brzuch",
    chest: "Klatka piersiowa",
    biceps: "Biceps",
    forearm: "Przedramię"
  }.freeze
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
  BRISTOL_DESCRIPTIONS = {
    1 => "Twardy, zbity",
    2 => "Lekko grudkowaty",
    3 => "Zwarty z pęknięciami",
    4 => "Gładki i miękki",
    5 => "Miękkie kawałki",
    6 => "Papkowaty",
    7 => "Wodnisty"
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
  scope :chronological, -> { order(created_at: :asc) }
  scope :within_date_range, ->(date_from, date_to) { where(created_at: date_from.beginning_of_day..date_to.end_of_day) }

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

  def circumference_rows
    BODY_MEASUREMENT_FIELDS.filter_map do |field|
      value = public_send(field)
      next if value.blank?

      { label: BODY_MEASUREMENT_LABELS.fetch(field), value: value }
    end
  end

  def photo_gallery_items
    [
      { label: "Przód", attachment: photo_front },
      { label: "Tył", attachment: photo_back },
      { label: "Bok", attachment: photo_side }
    ]
  end

  def attached_photos
    [ photo_front, photo_back, photo_side ].select(&:attached?)
  end

  def circumference_badges(limit: 3)
    circumference_rows.first(limit)
  end

  def self.comparison_rows(first_entry, last_entry)
    COMPARISON_FIELDS.filter_map do |config|
      first_value = first_entry.public_send(config[:field])
      last_value = last_entry.public_send(config[:field])
      next if first_value.blank? && last_value.blank?

      {
        field: config[:field],
        label: config[:label],
        unit: config[:unit],
        positive_trend: config[:positive_trend],
        first_value: first_value,
        last_value: last_value,
        delta: compute_delta(first_value, last_value)
      }
    end
  end

  def self.compute_delta(first_value, last_value)
    return if first_value.blank? || last_value.blank?

    last_value - first_value
  end

  def self.delta_between(previous_entry, latest_entry, field)
    return if previous_entry.blank? || latest_entry.blank?

    previous_value = previous_entry.public_send(field)
    latest_value = latest_entry.public_send(field)
    return if previous_value.blank? || latest_value.blank?

    latest_value - previous_value
  end

  def self.prefill_attributes_from(entry)
    return {} if entry.blank?

    entry.attributes.symbolize_keys.slice(*PREFILL_FIELDS)
  end
end
