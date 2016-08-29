class RecepcionParaTransf < ActiveRecord::Base
  belongs_to :recepcion_de_bien_de_consumo
  belongs_to :transferencia
end
