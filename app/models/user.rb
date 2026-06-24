class User < ApplicationRecord
  has_many :measurement_entries, dependent: :destroy

  has_secure_password

  before_validation :normalize_email, :normalize_username, :assign_username_from_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 32 }

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def normalize_username
    self.username = username.to_s.downcase.strip.presence
  end

  def assign_username_from_email
    self.username ||= email.to_s.split("@").first.parameterize(separator: "_").presence
  end
end
