class AddEstadoToConsumoDirecto < ActiveRecord::Migration
  def change
    add_column :consumos_directo, :estado, :integer
  end
end
