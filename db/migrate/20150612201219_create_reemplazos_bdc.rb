class CreateReemplazosBdc < ActiveRecord::Migration
  def change
	  create_table :reemplazos_bdc do |t|
	      t.integer :bdc_viejo_id
	      t.integer :bdc_nuevo_id

	      t.timestamps null: false
	  end
  add_index :reemplazos_bdc, :bdc_viejo_id
  add_index :reemplazos_bdc, :bdc_nuevo_id
  add_index :reemplazos_bdc, [:bdc_viejo_id, :bdc_nuevo_id], unique: true
  end
end
