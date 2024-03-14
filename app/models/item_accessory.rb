class ItemAccessory < ApplicationRecord
  belongs_to :item
  belongs_to :accessory

  validates :item_id, presence: true
  validates :accessory_id, presence: true
end
