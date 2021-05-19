class NameTableCategoryListing < ActiveRecord::Migration[6.0]
  def change
    rename_table :categories_listings, :category_listings
  end
end
