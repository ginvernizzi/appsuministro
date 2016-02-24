class ItemStock < ActiveRecord::Base  
  belongs_to :bien_de_consumo
  belongs_to :deposito
  belongs_to :costo_de_bien_de_consumo  
  belongs_to :ingreso_manual_a_stock

  validates :cantidad, presence: true
  # validates :costo_de_bien_de_consumo, presence: true
  validates :costo_de_bien_de_consumo_id, presence: true 
  #accepts_nested_attributes_for :deposito

end
