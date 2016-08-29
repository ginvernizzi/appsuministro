class AddEstadoToTransferencias < ActiveRecord::Migration
  def change
    add_column :transferencias, :estado, :integer
  end
end
