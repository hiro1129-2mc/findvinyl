class Item < ApplicationRecord
  belongs_to :user
  belongs_to :title
  belongs_to :artist_name
  belongs_to :press_country
  belongs_to :matrix_number
  belongs_to :condition

  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags
  has_many :item_accessories, dependent: :destroy
  has_many :accessories, through: :item_accessories

  validates :user_id, presence: true
  validates :title_id, presence: true
  validates :artist_name_id, presence: true

  enum role: { collection: 0, want: 1 }
end
