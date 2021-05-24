class Journey < ApplicationRecord
  belongs_to :user, optional: true
  has_many :itineraries, dependent: :destroy
  has_many :listings, through: :itineraries

  validates :name, presence: true
end
