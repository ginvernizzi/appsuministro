class BienDeConsumoParaConsumir < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :consumo_directo
  belongs_to :deposito

  attr_accessor :fecha_inicio
  attr_accessor :fecha_fin
  #attr_accessible :flag  
end
