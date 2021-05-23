class Journey < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :itineraries, dependent: :destroy
  has_many :listings, through: :itineraries
end
