class Tag < ApplicationRecord
  has_many :listing_tags
  has_many :listings, through: :listing_tags
end
