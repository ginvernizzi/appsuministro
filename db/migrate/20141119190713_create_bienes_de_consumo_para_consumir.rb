class CreateBienesDeConsumoParaConsumir < ActiveRecord::Migration
  def change
    create_table :bienes_de_consumo_para_consumir do |t|
      t.integer :cantidad
      t.decimal :costo
      t.references :bien_de_consumo, index: true
      t.references :consumo_directo, index: true

      t.timestamps
    end
  end
end
