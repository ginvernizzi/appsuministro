class AddSotckMinimoToBienDeConsumo < ActiveRecord::Migration
  def change
    add_column :bienes_de_consumo, :stock_minimo, :integer
  end
end
