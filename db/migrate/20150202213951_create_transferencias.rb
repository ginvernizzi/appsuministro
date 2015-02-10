class CreateTransferencias < ActiveRecord::Migration
  def change
    create_table :transferencias do |t|
      t.date :fecha
      t.references :area, index: true
      t.references :deposito, index: true     
      t.timestamps
    end
  end
end
