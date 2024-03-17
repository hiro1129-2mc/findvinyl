class ItemAccessory < ApplicationRecord
  belongs_to :item
  belongs_to :accessory

  validates :accessory_id, uniqueness: { scope: :item_id }
end
