class CreateJoinTableDocumentoDeRecepcionRecepcionDeBienDeConsumo < ActiveRecord::Migration
  def change
    create_join_table :documentos_de_recepcion, :recepciones_de_bien_de_consumo do |t|
      t.belongs_to :documento_de_recepcion, :null => false
      t.belongs_to :recepcion_de_bien_de_consumo, :null => false
            
    end

	add_index :documentos_de_recepcion_recepciones_de_bien_de_consumo, [:documento_de_recepcion_id, :recepcion_de_bien_de_consumo_id], :name => 'index_doc_de_recep_recep_de_bien_de_consumo' 
  end  
end
