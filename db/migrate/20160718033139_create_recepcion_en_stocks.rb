class CreateRecepcionEnStocks < ActiveRecord::Migration
  def change
    create_table :recepcion_en_stocks do |t|
      t.references :recepcion_de_bien_de_consumo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
