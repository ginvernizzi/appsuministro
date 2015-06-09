class AddFechaDeBajaToClase < ActiveRecord::Migration
  def change
    add_column :clases, :fecha_de_baja, :datetime
  end
end
