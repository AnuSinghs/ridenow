class DropItinerariesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :itineraries
  end
end
