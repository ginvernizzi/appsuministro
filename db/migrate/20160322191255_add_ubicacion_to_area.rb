class AddUbicacionToArea < ActiveRecord::Migration
  def change
    add_column :areas, :ubicacion, :string
  end
end
