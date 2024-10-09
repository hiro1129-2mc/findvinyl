class Review < ApplicationRecord
  validates :content, presence: true, length: { maximum: 10_000 }

  belongs_to :user
  belongs_to :shop
end
