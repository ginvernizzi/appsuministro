class CreateClases < ActiveRecord::Migration
  def change
    create_table :clases do |t|
      t.string :codigo, limit: 5
      t.string :nombre
      t.references :partida_parcial, index: true

      t.timestamps
    end
  end
end
