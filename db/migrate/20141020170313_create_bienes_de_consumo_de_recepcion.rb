class CreateBienesDeConsumoDeRecepcion < ActiveRecord::Migration
  def change
    create_table :bienes_de_consumo_de_recepcion do |t|
      t.references :bien_de_consumo, index: true
      t.integer :cantidad
      t.decimal :costo
      t.references :recepcion_de_bien_de_consumo, index: true

      t.timestamps
    end
  end
end
