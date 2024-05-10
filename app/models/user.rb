class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_many :items, dependent: :destroy
  has_many :records, dependent: :destroy

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    self.confirmation_sent_at = Time.current
    save!
    confirmation_token
  end

  def confirmation_token_expires?
    confirmation_sent_at > 2.hours.ago
  end
end
