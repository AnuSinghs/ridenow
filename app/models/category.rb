class Category < ApplicationRecord
  has_many :category_listings, dependent: :destroy
  has_many :listings, through: :category_listings
end
