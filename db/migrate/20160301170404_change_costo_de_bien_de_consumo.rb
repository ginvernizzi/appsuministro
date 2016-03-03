class ChangeCostoDeBienDeConsumo < ActiveRecord::Migration
  def change
  	change_column :costos_de_bien_de_consumo, :costo, :decimal, precision: 8, scale: 3
  end
end
