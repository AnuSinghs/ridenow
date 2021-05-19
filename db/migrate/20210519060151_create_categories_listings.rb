class CreateCategoriesListings < ActiveRecord::Migration[6.0]
  def change
    create_table :categories_listings do |t|
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
