class CreateTiposDeDocumentos < ActiveRecord::Migration
  def change
    create_table :tipos_de_documentos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
