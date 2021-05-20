class AddCategoryToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :category, null: true, foreign_key: true
  end
end
