class RecepcionParaConsumoDirecto < ActiveRecord::Base
  belongs_to :recepcion_de_bien_de_consumo
  belongs_to :consumo_directo

  validates :recepcion_de_bien_de_consumo, presence: true
  validates :consumo_directo, presence: true
end
