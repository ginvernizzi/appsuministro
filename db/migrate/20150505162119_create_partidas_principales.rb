class CreatePartidasPrincipales < ActiveRecord::Migration
  def change
    create_table :partidas_principales do |t|
      t.string :codigo, limit: 1
      t.string :nombre
      t.references :inciso, index: true

      t.timestamps
    end
  end
end
