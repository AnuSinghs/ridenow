class UpdateCoords < ActiveRecord::Migration[6.0]
  def change
    change_column :listings, :coordinates, :integer
  end
end
