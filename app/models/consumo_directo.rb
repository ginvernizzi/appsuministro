class ConsumoDirecto < ActiveRecord::Base

  ESTADOS = { :ACTIVO => 1, :ANULADO => 2 }
  
  belongs_to :obra_proyecto
  belongs_to :area
  belongs_to :deposito
  belongs_to :persona
  
  has_many :bienes_de_consumo_para_consumir

  has_one :recepcion_para_consumo_directo
  
  validates :fecha, presence: true
  validates :area, presence: true    
  validates :obra_proyecto, presence: true   
   
end
