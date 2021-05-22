class Listing < ApplicationRecord
  belongs_to :category, optional: true
  has_many :listing_tags, dependent: :destroy
  has_many :tags, through: :listing_tags

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_one_attached :photo

  scope :by_latitude, ->(latitude_start, latitude_end) do
    where("latitude >= ?", "#{latitude_start}").where("latitude <= ?", "#{latitude_end}") if latitude_start.present?
  end

  scope :by_longitude, ->(longitude_start, longitude_end) do
    where("longitude >= ?", "#{longitude_start}").where("longitude <= ?", "#{longitude_end}") if longitude_start.present?
  end
end
