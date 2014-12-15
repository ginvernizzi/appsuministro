class RemoveCodigoFromObraProyecto < ActiveRecord::Migration
  def change
    remove_column :obras_proyectos, :codigo, :string
  end
end
