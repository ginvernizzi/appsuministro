class CreateItemsStock < ActiveRecord::Migration
  def change
    create_table :items_stock do |t|
      t.references :bien_de_consumo, index: true
      t.decimal :cantidad
      t.references :costo_de_bien_de_consumo, index: true
      t.references :deposito, index: true

      t.timestamps
    end
  end
end
