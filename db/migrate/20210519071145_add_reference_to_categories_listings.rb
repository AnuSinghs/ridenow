class AddReferenceToCategoriesListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :categories_listings, :listings, foreign_key: true
  end
end
