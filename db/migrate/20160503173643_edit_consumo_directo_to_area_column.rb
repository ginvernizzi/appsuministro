class EditConsumoDirectoToAreaColumn < ActiveRecord::Migration
  def change
  	add_foreign_key :consumos_directo, :areas
  end
end


