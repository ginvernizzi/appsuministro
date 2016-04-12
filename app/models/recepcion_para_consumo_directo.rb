class RecepcionParaConsumoDirecto < ActiveRecord::Base
  belongs_to :RecepcionDeBienDeConsumo
  belongs_to :ConsumoDirecto
end
