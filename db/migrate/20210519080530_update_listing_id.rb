class UpdateListingId < ActiveRecord::Migration[6.0]
  def change
    remove_reference :categories_listings, :listings
    add_reference :categories_listings, :listing, foreign_key: true
  end
end
