class Listing < ApplicationRecord
  belongs_to :category, optional: true
  has_many :listing_tags, dependent: :destroy
  has_many :tags, through: :listing_tags

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_one_attached :photo
end
