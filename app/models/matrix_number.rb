class MatrixNumber < ApplicationRecord
  has_many :items

  validates :number, presence: true, uniqueness: true, length: { maximum: 255 }
end
