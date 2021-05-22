class CreateItineraries < ActiveRecord::Migration[6.0]
  def change
    create_table :itineraries, id: false do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :journey, null: false, foreign_key: true

      t.timestamps
    end
  end
end
