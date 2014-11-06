class BienDeConsumoDeRecepcion < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :recepcion_de_bien_de_consumo
  
  validates :bien_de_consumo, presence: true
  validates :cantidad, presence: true
  validates :costo, presence: true
  
  #accepts_nested_attributes_for :bien_de_consumo, :allow_destroy => true    
end
