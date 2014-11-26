class CostoDeBienDeConsumoHistorico < ActiveRecord::Base
  belongs_to :bien_de_consumo

  ORIGEN = { :manual => 1, :'desde evaluacion' => 2}
end
