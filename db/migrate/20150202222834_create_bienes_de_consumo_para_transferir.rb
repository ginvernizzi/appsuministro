class CreateBienesDeConsumoParaTransferir < ActiveRecord::Migration
  def change
    create_table :bienes_de_consumo_para_transferir do |t|
      t.decimal :costo
      t.integer :cantidad
      t.references :bien_de_consumo, index: true
      t.references :transferencia, index: true

      t.timestamps
    end
  end
end
