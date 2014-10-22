class CreateDocumentosDeRecepcion < ActiveRecord::Migration
  def change
    create_table :documentos_de_recepcion do |t|
      t.references :tipo_de_documento, index: true
      t.string :numero_de_documento

      t.timestamps
    end
  end
end
