class Accessory < ApplicationRecord
  has_many :item_accessories

  validates :name, presence: true
end
