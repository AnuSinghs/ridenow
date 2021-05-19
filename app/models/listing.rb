class Listing < ApplicationRecord
  has_many :category_listings, dependent: :destroy
  has_many :categories, through: :category_listings
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_one_attached :photo
end
