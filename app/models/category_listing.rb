class CategoryListing < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :listing, optional: true
end
