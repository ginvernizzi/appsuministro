class AddUnidadDeMedidaToBienesDeConsumo < ActiveRecord::Migration
  def change
    add_column :bienes_de_consumo, :unidad_de_medida, :string
  end
end
