class AddFechaToClase < ActiveRecord::Migration
  def change
    add_column :clases, :fecha, :datetime
  end
end
