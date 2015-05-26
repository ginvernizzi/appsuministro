class AddClaseToBienDeConsumo < ActiveRecord::Migration
  def change
    add_reference :bienes_de_consumo, :clase, index: true
  end
end
