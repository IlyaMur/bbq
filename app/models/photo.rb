class Photo < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :photo, presence: true

  mount_uploader :photo, PhotoUploader

  scope :persisted, -> { where 'id IS NOT NULL' }
end
