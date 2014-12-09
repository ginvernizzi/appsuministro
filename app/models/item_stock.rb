class ItemStock < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :deposito

  accepts_nested_attributes_for :deposito
end
