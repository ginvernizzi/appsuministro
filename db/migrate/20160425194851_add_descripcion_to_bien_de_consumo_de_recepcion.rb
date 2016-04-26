class AddDescripcionToBienDeConsumoDeRecepcion < ActiveRecord::Migration
  def change
    add_column :bienes_de_consumo_de_recepcion, :descripcion, :string
  end
end
