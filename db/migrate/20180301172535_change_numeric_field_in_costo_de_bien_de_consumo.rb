class ChangeNumericFieldInCostoDeBienDeConsumo < ActiveRecord::Migration
  def self.up
   change_column :costos_de_bien_de_consumo, :costo, :decimal, :precision => 10, :scale => 3
  end
end