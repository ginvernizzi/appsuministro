class CreateRecepcionesDeBienDeConsumo < ActiveRecord::Migration
  def change
    create_table :recepciones_de_bien_de_consumo do |t|
      t.datetime :fecha
      t.integer :estado
      t.text :descripcion_provisoria
      t.references :documento_de_recepcion


      t.timestamps
    end
    add_index :recepciones_de_bien_de_consumo, :documento_de_recepcion_id, :name => 'index_recep_de_bien_de_consumo_on_doc_de_recep_id'
  end
end

    