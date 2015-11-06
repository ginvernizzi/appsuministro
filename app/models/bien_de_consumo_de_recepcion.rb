class BienDeConsumoDeRecepcion < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :recepcion_de_bien_de_consumo
    
  validates :cantidad, presence: true   

  # validates :costo, :presence => true,
  #           :numericality => true,
  #           :format => { :with => /^\d{1,4}(\.\d{0,4})?$/ }

  validates :costo, :presence => true 										  

  validates :bien_de_consumo_id, presence: true  
  
  #accepts_nested_attributes_for :bien_de_consumo, :allow_destroy => true    
  #validates_associated :bien_de_consumo
end
