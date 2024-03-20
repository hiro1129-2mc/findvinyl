class ArtistName < ApplicationRecord
  has_many :items

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['items']
  end
end
