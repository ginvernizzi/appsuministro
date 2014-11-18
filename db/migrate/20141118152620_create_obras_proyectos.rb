class CreateObrasProyectos < ActiveRecord::Migration
  def change
    create_table :obras_proyectos do |t|
      t.string :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
