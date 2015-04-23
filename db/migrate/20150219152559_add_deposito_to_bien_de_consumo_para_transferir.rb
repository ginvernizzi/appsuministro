class AddDepositoToBienDeConsumoParaTransferir < ActiveRecord::Migration
  def change
    add_reference :bienes_de_consumo_para_transferir, :deposito, index: true
  end
end
