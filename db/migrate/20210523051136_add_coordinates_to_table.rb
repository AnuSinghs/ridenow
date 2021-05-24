class AddCoordinatesToTable < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :coordinates, :float
  end
end
