class CreateJourneys < ActiveRecord::Migration[6.0]
  def change
    create_table :journeys do |t|
      t.string :destination
      t.string :origin
      t.boolean :privacy
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
