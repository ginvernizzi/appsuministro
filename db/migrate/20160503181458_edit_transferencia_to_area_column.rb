class EditTransferenciaToAreaColumn < ActiveRecord::Migration
  def change
  	add_foreign_key :transferencias, :areas
  end
end
