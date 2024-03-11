class ArtistCreditName < ApplicationRecord
  belongs_to :artist_credit
  belongs_to :artist

  validates :artist_credit_id, presence: true
  validates :artist_id, presence: true
end
