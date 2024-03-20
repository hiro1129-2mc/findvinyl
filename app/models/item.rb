class Item < ApplicationRecord
  belongs_to :user
  belongs_to :title
  belongs_to :artist_name
  belongs_to :press_country, optional: true
  belongs_to :matrix_number, optional: true
  belongs_to :condition, optional: true

  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags
  has_many :item_accessories, dependent: :destroy
  has_many :accessories, through: :item_accessories

  validates :user_id, presence: true
  validates :title_id, presence: true
  validates :artist_name_id, presence: true
  validates :user_note, length: { maximum: 500 }

  enum role: { collection: 0, want: 1 }

  scope :collection_items, -> { where(role: 0).joins(:artist_name).order('artist_names.name ASC') }
  scope :want_items, -> { where(role: 1).joins(:artist_name).order('artist_names.name ASC') }
  scope :title_contain, ->(word) { joins(:title).where('titles.name LIKE ?', "%#{word}%") }
  scope :artist_name_contain, ->(word) { joins(:artist_name).where('artist_names.name LIKE ?', "%#{word}%") }

  def self.ransackable_attributes(auth_object = nil)
    ["artist_name_id", "condition_id", "matrix_number_id", "press_country_id", "role", "title_id", "user_note", "tags"]
  end

  def self.ransackable_associations(auth_object = nil)
  end

  def find_or_create_related_objects(attributes)
    attributes.each do |relation, value|
      next if value.blank?
  
      relation_class = relation.to_s.classify.constantize
  
      column_name = case relation.to_s
                    when "matrix_number" then :number
                    when "condition" then :grade
                    else :name
                    end
  
      object = if relation.to_s == "matrix_number"
                 MatrixNumber.find_or_create_by(column_name => value)
               else
                 relation_class.find_or_create_by(column_name => value.strip)
               end
  
      self.send("#{relation}_id=", object.id)
    end
  end

  def save_with_tags(tag_names:)
    ActiveRecord::Base.transaction do
      self.tags = tag_names.map { |name| Tag.find_or_initialize_by(name: name.strip) }
      save!
    end
    true
  rescue StandardError
    false
  end

  def tag_names
    tags.map(&:name).join(',')
  end

  def save_with_accessories(accessory_names:)
    ActiveRecord::Base.transaction do
      self.accessories = accessory_names.map { |name| Accessory.find_or_initialize_by(name: name.strip) }
      save!
    end
    true
  rescue StandardError
    false
  end

  def accessory_names
    accessories.map(&:name).join(',')
  end
end
