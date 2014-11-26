class CreateCostosDeBienDeConsumo < ActiveRecord::Migration
  def change
    create_table :costos_de_bien_de_consumo do |t|
      t.date :fecha
      t.references :bien_de_consumo, index: true
      t.decimal :costo
      t.string :usuario
      t.integer :origen

      t.timestamps
    end
  end
end
