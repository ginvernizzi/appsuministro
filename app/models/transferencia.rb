class Transferencia < ActiveRecord::Base
	ESTADOS = { :ACTIVO => 1, :ANULADO => 2 }
  	belongs_to :area
  	belongs_to :deposito    
  
  	has_many :bienes_de_consumo_para_transferir
  	has_one :recepcion_de_bien_de_consumo
  	has_one :recepcion_para_transf

  	validates :fecha, presence: true
  	validates :area, presence: true    
  	validates :deposito_id, presence: true    
end
