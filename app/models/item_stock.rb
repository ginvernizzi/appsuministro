class ItemStock < ActiveRecord::Base  
  belongs_to :bien_de_consumo
  belongs_to :deposito
  belongs_to :costo_de_bien_de_consumo  

  #accepts_nested_attributes_for :deposito
end
