class Condition < ApplicationRecord
  has_many :items

  validates :grede, presence: true, uniqueness: true
end
