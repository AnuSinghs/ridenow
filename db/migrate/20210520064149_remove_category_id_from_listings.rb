class RemoveCategoryIdFromListings < ActiveRecord::Migration[6.0]
  def change
    remove_reference :listings, :categories, foreign_key: true
  end
end
