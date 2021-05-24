class AddRouteImgNameToJourneys < ActiveRecord::Migration[6.0]
  def change
    add_column :journeys, :name, :string
    add_column :journeys, :route_url, :string
  end
end
