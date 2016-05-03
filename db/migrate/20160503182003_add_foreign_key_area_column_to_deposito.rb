class AddForeignKeyAreaColumnToDeposito < ActiveRecord::Migration
  def change
  	add_foreign_key :depositos, :areas
  end
end
