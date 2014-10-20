class CreateJoinTableDocumentoDeRecepcionRecepcionDeBienDeConsumo < ActiveRecord::Migration
  def change
    create_join_table :documentos_de_recepcion, :recepciones_de_bien_de_consumo do |t|
      t.belongs_to :documento_de_recepcion, :null => false
      t.belongs_to :recepcion_de_bien_de_consumo, :null => false

      t.index [:documento_de_recepcion_id, :recepcion_de_bien_de_consumo_id]
      # t.index [:recepcion_de_bien_de_consumo_id, :documento_de_recepcion_id]
    end
  end
end
