class CreateReemplazosClase < ActiveRecord::Migration
  def change
    create_table :reemplazos_clase do |t|
      t.integer :clase_vieja_id
      t.integer :clase_nueva_id

      t.timestamps null: false
    end
  add_index :reemplazos_clase, :clase_vieja_id
  add_index :reemplazos_clase, :clase_nueva_id
  add_index :reemplazos_clase, [:clase_vieja_id, :clase_nueva_id], unique: true
  end
end
