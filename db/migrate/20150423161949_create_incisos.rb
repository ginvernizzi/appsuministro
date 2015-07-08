class CreateIncisos < ActiveRecord::Migration
  def change
    create_table :incisos do |t|
      t.string :codigo, limit: 1
      t.string :nombre

      t.timestamps
    end
  end
end
