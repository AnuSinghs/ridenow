class AddDefaultToJourney < ActiveRecord::Migration[6.0]
  def change
    change_column :journeys, :privacy, :boolean, default: false
  end
end
