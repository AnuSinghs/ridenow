class ListingTag < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :listing, optional: true
end
