class Transferencia < ActiveRecord::Base
  belongs_to :area
  belongs_to :deposito    
  
  has_many :bienes_de_consumo_para_transferir

  validates :fecha, presence: true
  validates :area, presence: true    
  validates :deposito, presence: true    
end
