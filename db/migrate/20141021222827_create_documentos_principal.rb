class CreateDocumentosPrincipal < ActiveRecord::Migration
  def change
    create_table :documentos_principal do |t|
      t.references :documento_de_recepcion, index: true
      t.references :recepcion_de_bien_de_consumo, index: true

      t.timestamps
    end
  end
end
