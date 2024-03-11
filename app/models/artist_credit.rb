class ArtistCredit < ApplicationRecord
  has_many :artist_credit_names
  has_many :artists, through: :artist_credit_names
  has_many :releases

  validates :name, presence: true
end
