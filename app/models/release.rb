class Release < ApplicationRecord
  belongs_to :artist_credit
  has_many :mediums
  has_many :medium_formats, through: :mediums

  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true
  validates :artist_credit_id, presence: true

  def self.search_with_associations(name)
    search_by_name(name)
      .includes(artist_credit: :artist, mediums: :medium_format)
      .references(:artist_credits, :medium_formats)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
