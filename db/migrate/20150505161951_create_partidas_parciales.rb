class CreatePartidasParciales < ActiveRecord::Migration
  def change
    create_table :partidas_parciales do |t|
      t.string :codigo, limit: 1
      t.string :nombre
      t.references :partida_principal, index: true

      t.timestamps
    end
  end
end
