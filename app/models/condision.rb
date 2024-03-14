class Condision < ApplicationRecord
  has_many :items

  validates :grede, presence: true
end
