class AddClaseToBienDeConsumo < ActiveRecord::Migration
  def change
    add_reference :bienes_de_consumo, :clase, index: true, foreign_key: true
  end
end
