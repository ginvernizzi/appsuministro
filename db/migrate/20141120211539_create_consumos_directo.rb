class CreateConsumosDirecto < ActiveRecord::Migration
  def change
    create_table :consumos_directo do |t|
      t.date :fecha     
      t.references :area, index: true
      t.references :obra_proyecto, index: true

      t.timestamps
    end
  end
end
