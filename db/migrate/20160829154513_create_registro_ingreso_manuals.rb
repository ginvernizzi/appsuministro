class CreateRegistroIngresoManuals < ActiveRecord::Migration
  def change
    create_table :registro_ingreso_manuals do |t|
      t.references :bien_de_consumo, index: true, foreign_key: true
      t.decimal :cantidad
      t.decimal :costo
      t.references :deposito, index: true, foreign_key: true
      t.string :usuario

      t.timestamps null: false
    end
  end
end
