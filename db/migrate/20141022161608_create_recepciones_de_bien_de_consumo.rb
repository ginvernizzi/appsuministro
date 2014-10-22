class CreateRecepcionesDeBienDeConsumo < ActiveRecord::Migration
  def change
    create_table :recepciones_de_bien_de_consumo do |t|
      t.datetime :fecha
      t.integer :estado
      t.text :descripcion_provisoria

      t.timestamps
    end
  end
end
