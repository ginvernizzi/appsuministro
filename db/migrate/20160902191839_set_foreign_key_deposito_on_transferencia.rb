class SetForeignKeyDepositoOnTransferencia < ActiveRecord::Migration
  def change
  	add_foreign_key :transferencias, :depositos, column: :deposito_id
  end
end
