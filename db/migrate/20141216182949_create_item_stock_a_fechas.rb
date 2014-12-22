class CreateItemStockAFechas < ActiveRecord::Migration
  def change
    create_table :item_stock_a_fechas do |t|
      t.references :bien_de_consumo, index: true
      t.decimal :costo
      t.integer :cantidad
      t.references :deposito, index: true

      t.timestamps
    end
  end
end
