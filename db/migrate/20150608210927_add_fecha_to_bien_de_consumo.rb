class AddFechaToBienDeConsumo < ActiveRecord::Migration
  def change
    add_column :bienes_de_consumo, :fecha, :datetime
  end
end
