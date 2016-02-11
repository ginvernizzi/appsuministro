class CreateIngresoManualAStocks < ActiveRecord::Migration
  def change
    create_table :ingreso_manual_a_stocks do |t|
      t.date :fecha
      
      t.timestamps null: false
    end
  end
end
