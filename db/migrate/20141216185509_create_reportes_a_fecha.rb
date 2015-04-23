class CreateReportesAFecha < ActiveRecord::Migration
  def change
    create_table :reportes_a_fecha do |t|
      t.date :fecha
      t.text :stock_diario

      t.timestamps
    end
  end
end
