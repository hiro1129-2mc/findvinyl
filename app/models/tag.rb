class Tag < ApplicationRecord
  has_many :item_tags

  validates :name, presence: true
end
