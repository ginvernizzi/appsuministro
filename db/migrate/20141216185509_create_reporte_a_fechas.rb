class CreateReporteAFechas < ActiveRecord::Migration
  def change
    create_table :reporte_a_fechas do |t|
      t.date :fecha
      t.text :stock_diario

      t.timestamps
    end
  end
end
