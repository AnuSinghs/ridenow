class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.float :lat
      t.float :long
      t.text :address
      t.string :name
      t.text :description
      t.float :rating

      t.timestamps
    end
  end
end
