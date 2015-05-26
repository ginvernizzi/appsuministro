class AddDetalleAdicionalToBienesDeConsumo < ActiveRecord::Migration
  def change
    add_column :bienes_de_consumo, :detalle_adicional, :text
  end
end
