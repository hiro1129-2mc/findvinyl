class MatrixNumber < ApplicationRecord
  has_many :items

  validates :number, presence: true, uniqueness: true
end
