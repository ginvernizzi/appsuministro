class AddDepositoToBienDeConsumoParaConsumir < ActiveRecord::Migration
  def change
    add_reference :bienes_de_consumo_para_consumir, :deposito, index: true
  end
end
