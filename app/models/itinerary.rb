class Itinerary < ApplicationRecord
  belongs_to :listing, optional: true
  belongs_to :journey, optional: true
end
