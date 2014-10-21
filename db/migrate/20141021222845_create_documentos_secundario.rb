class CreateDocumentosSecundario < ActiveRecord::Migration
  def change
    create_table :documentos_secundario do |t|
      t.references :documento_de_recepcion, index: true, unique: true
      t.references :recepcion_de_bien_de_consumo, index: true, unique: true

      t.timestamps
    end
  end
end
