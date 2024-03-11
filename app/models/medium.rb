class Medium < ApplicationRecord
  self.table_name = 'mediums'
  belongs_to :release
  belongs_to :medium_format, optional: true

  validates :release_id, presence: true
end
