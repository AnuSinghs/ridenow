class Journey < ApplicationRecord
  belongs_to :user
  has_many :itineraries, dependent: :destroy
  has_many :listings, through: :itineraries
end
