class CreateBienesDeConsumoDeRecepcion < ActiveRecord::Migration
  def change
    create_table :bienes_de_consumo_de_recepcion do |t|
      t.references :bien_de_consumo
      t.integer :cantidad
      t.decimal :costo
      t.references :recepcion_de_bien_de_consumo

      t.timestamps
    end

	add_index :bienes_de_consumo_de_recepcion, :bien_de_consumo_id, :name => 'index_bienes_de_consumo_de_recep_on_bien_de_consumo_id'

	add_index :bienes_de_consumo_de_recepcion, :recepcion_de_bien_de_consumo_id, :name => 'index_bienes_de_consumo_de_recep_on_recep_de_bien_de_consumo_id'
  end
end
