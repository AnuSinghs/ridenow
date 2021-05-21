class ChangeTableNameJourneysListings < ActiveRecord::Migration[6.0]
  def change
    rename_table('journeys_listings', 'itinerary')
  end
end
