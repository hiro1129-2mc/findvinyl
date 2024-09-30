class Release < ApplicationRecord
  belongs_to :artist_credit
  has_many :mediums
  has_many :medium_formats, through: :mediums

  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true
  validates :artist_credit_id, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
