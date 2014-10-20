class CreateBienesDeConsumo < ActiveRecord::Migration
  def change
    create_table :bienes_de_consumo do |t|
      t.string :nombre
      t.string :codigo

      t.timestamps
    end
  end
end
