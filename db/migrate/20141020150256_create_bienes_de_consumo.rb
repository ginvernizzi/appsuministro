class CreateBienesDeConsumo < ActiveRecord::Migration
  def change
    create_table :bienes_de_consumo do |t|
      t.string :nombre
      t.string :codigo, limit: 4      	  

      t.timestamps
    end
  end
end
