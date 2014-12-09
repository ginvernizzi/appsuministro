class CreateDepositos < ActiveRecord::Migration
  def change
    create_table :depositos do |t|
      t.references :area, index: true
      t.string :nombre

      t.timestamps
    end
  end
end
