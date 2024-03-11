class Artist < ApplicationRecord
  has_many :artist_credit_names
  has_many :artist_credits, through: :artist_credit_names

  validates :gid, presence: true, uniqueness: true
  validates :name, presence: true

  scope :search_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
