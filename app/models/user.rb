class User < ApplicationRecord
  has_many :measurement_entries, dependent: :destroy

  has_secure_password

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end
