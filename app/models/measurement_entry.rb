class MeasurementEntry < ApplicationRecord
  BODY_MEASUREMENT_FIELDS = %i[calf thigh buttocks waist abdomen chest biceps forearm].freeze

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
end
