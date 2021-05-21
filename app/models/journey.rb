class Journey < ApplicationRecord
  belongs_to :user
  has_many :journeys_listings, dependent: :destroy
  has_many :listings, through: :itinerary

  validates :destination, presence: true
  validates :origin, presence: true
end
