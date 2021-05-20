class DropCategoriesListingTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :category_listings
  end
end
