class Record < ApplicationRecord
  belongs_to :user

  has_many :record_items, dependent: :destroy, autosave: false
  has_many :items, through: :record_items

  validates :content, length: { maximum: 10_000 }

  def start_time
    created_at
  end
end
