class ConsumoDirecto < ActiveRecord::Base
  belongs_to :obra_proyecto
  belongs_to :area
  belongs_to :deposito
  belongs_to :persona
  
  has_many :bienes_de_consumo_para_consumir
  
  validates :fecha, presence: true
  validates :area, presence: true    
  validates :obra_proyecto, presence: true   
   
end
