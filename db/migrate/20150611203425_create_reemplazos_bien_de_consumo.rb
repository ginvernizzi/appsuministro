class CreateReemplazosBienesDeConsumo < ActiveRecord::Migration
  def change
    create_table :reemplazos_bien_de_consumo do |t|
      t.references :bien_de_consumo, index: true, foreign_key: true
      t.references :bien_de_consumo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
