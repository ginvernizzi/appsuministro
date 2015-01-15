class ConsumoDirecto < ActiveRecord::Base
  belongs_to :obra_proyecto
  belongs_to :area
  
  has_many :bienes_de_consumo_para_consumir
  
  validates :fecha, presence: true
  validates :area_id, presence: true    
  validates :obra_proyecto_id, presence: true       
end
