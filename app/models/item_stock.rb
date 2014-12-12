class ItemStock < ActiveRecord::Base
  #default_scope { order('bien_de_consumo DESC') }

  belongs_to :bien_de_consumo
  belongs_to :deposito
  belongs_to :costo_de_bien_de_consumo  

  accepts_nested_attributes_for :deposito
end
