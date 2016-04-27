class CreateEtiquetasDeImplementacion < ActiveRecord::Migration
  def change
    create_table :etiquetas_de_implementacion do |t|
      t.string :descripcion
    end
  end
end
