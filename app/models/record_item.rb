class RecordItem < ApplicationRecord
  belongs_to :record
  belongs_to :item

  validates :record_id, uniqueness: { scope: :item_id }
end
