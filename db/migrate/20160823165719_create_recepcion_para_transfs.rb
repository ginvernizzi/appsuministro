class CreateRecepcionParaTransfs < ActiveRecord::Migration
  def change
    create_table :recepcion_para_transfs do |t|
      t.references :recepcion_de_bien_de_consumo, index: true, foreign_key: true
      t.references :transferencia, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
