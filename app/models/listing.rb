class Listing < ApplicationRecord
  belongs_to :category, optional: true
  has_many :listing_tags
  has_many :tags, through: :listing_tags
  has_many :itineraries

  validates :address, presence: true
  validates :name, presence: true

  geocoded_by :address, skip_index: true
  after_validation :geocode, if: :will_save_change_to_address?
  has_one_attached :photo

  scope :by_latitude, ->(latitude_start, latitude_end) do
    if latitude_start < latitude_end
      where("latitude >= ?", "#{latitude_start}").where("latitude <= ?", "#{latitude_end}") if latitude_start.present?
    else
      where("latitude >= ?", "#{latitude_end}").where("latitude <= ?", "#{latitude_start}") if latitude_start.present?
    end
  end

  scope :by_longitude, ->(longitude_start, longitude_end) do
    if longitude_start < longitude_end
      where("longitude >= ?", "#{longitude_start}").where("longitude <= ?", "#{longitude_end}") if longitude_start.present?
    else
      where("longitude >= ?", "#{longitude_end}").where("longitude <= ?", "#{longitude_start}") if longitude_start.present?
    end
  end

  scope :by_tag_eats, ->(tag_eats) do
    joins(:tags).where(tags: {name: tag_eats} ) if tag_eats.present?
  end

   scope :by_tag_sights, ->(tag_sights) do
    joins(:tags).where(tags: {name: tag_sights} ) if tag_sights.present?
  end

  scope :by_tag_eats, ->(tag_hawkers) do
    joins(:tags).where(tags: {name: tag_hawkers} ) if tag_hawkers.present?
  end

end
