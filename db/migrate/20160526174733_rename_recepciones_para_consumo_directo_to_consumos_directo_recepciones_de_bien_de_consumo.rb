class RenameRecepcionesParaConsumoDirectoToConsumosDirectoRecepcionesDeBienDeConsumo < ActiveRecord::Migration
  def change
    rename_table :recepciones_para_consumo_directo, :consumos_directo_recepciones_de_bien_de_consumo
  end 
end
