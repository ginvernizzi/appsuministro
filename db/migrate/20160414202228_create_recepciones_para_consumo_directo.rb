class CreateRecepcionesParaConsumoDirecto < ActiveRecord::Migration
  def change
    create_table(:recepciones_para_consumo_directo, id: false) do |t|
      t.references :recepcion_de_bien_de_consumo, foreign_key: true
      t.references :consumo_directo, foreign_key: true
    end

#	add_index :recepciones_para_consumo_directo, :recepcion_de_bien_de_consumo_id, :name => 'index_recep_para_cons_dir_on_recep_de_bien_de_consumo_id'

#	add_index :recepciones_para_consumo_directo, :consumo_directo_id, :name => 'index_recep_para_cons_dir_on_consumo_directo_id'    
  end
end

