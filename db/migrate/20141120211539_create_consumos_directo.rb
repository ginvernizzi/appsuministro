class CreateConsumosDirecto < ActiveRecord::Migration
  def change
    create_table :consumos_directo do |t|
      t.date :fecha
      t.string :area
      t.references :obra_proyecto, index: true

      t.timestamps
    end
  end
end
