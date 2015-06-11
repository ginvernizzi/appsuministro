class AddFechaDeBajaToBienDeConsumo < ActiveRecord::Migration
  def change
    add_column :bienes_de_consumo, :fecha_de_baja, :datetime
  end
end
