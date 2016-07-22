class Transferencia < ActiveRecord::Base
	ESTADOS = { :ACTIVO => 1, :ANULADO => 2 }
  	belongs_to :area
  	belongs_to :deposito    
  
  	has_many :bienes_de_consumo_para_transferir
  	has_one :recepcion_de_bien_de_consumo

  	validates :fecha, presence: true
  	validates :area, presence: true    
  	validates :deposito, presence: true    
end
