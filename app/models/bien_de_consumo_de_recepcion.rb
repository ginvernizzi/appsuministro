class BienDeConsumoDeRecepcion < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :recepcion_de_bien_de_consumo

  validates :cantidad, presence: true
  validates :costo, presence: true
end
