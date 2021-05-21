class ChangeTableNameItinerary < ActiveRecord::Migration[6.0]
  def change
    rename_table('itinerary', 'itineraries')
  end
end
