class MediumFormat < ApplicationRecord
  has_many :mediums

  validates :name, presence: true
end
