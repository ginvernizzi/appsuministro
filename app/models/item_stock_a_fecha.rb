class ItemStockAFecha < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :deposito
end
