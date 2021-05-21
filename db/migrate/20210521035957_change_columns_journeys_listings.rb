class ChangeColumnsJourneysListings < ActiveRecord::Migration[6.0]
  def change
    add_column :journeys_listings, :created_at, :datetime, null: false
    add_column :journeys_listings, :updated_at, :datetime, null: false
    add_foreign_key :journeys_listings, :journeys
    add_foreign_key :journeys_listings, :listings
  end
end
