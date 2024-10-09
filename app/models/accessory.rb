class Accessory < ApplicationRecord
  has_many :item_accessories, dependent: :destroy
  has_many :items, through: :item_accessories

  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
end
