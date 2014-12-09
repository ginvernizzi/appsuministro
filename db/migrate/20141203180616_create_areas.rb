class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :nombre
      t.string :responsable

      t.timestamps
    end
  end
end
