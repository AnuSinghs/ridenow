class CreateJoinTableJourneyListing < ActiveRecord::Migration[6.0]
  def change
    create_join_table :journeys, :listings do |t|
      t.index [:journey_id, :listing_id]
      t.index [:listing_id, :journey_id]
    end
  end
end
