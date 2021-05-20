class AddCategoriesKeyToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :categories, foreign_key: true
  end
end
