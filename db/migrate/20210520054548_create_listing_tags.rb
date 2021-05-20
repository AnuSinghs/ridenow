class CreateListingTags < ActiveRecord::Migration[6.0]
  def change
    create_table :listing_tags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
