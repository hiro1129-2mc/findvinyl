class Record < ApplicationRecord
  has_many :record_items, dependent: :destroy
  has_many :items, through: :record_items
end
