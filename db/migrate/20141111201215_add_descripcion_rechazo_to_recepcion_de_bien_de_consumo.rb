class AddDescripcionRechazoToRecepcionDeBienDeConsumo < ActiveRecord::Migration
  def change
    add_column :recepciones_de_bien_de_consumo, :descripcion_rechazo, :text
  end
end
