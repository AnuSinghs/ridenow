class AddPrimiaryKeyToItineraries < ActiveRecord::Migration[6.0]
  def change
    add_column :itineraries, :id, :primary_key
  end
end
