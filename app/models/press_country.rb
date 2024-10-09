class PressCountry < ApplicationRecord
  has_many :items

  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
end
