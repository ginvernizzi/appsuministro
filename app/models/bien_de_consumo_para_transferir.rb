class BienDeConsumoParaTransferir < ActiveRecord::Base
  belongs_to :bien_de_consumo
  belongs_to :transferencia

  validates :cantidad, presence: true   

  # validates :costo, :presence => true,
  #           :numericality => true,
  #           :format => { :with => /^\d{1,4}(\.\d{0,4})?$/ }

  validates :costo, :presence => true 										  

  validates :bien_de_consumo_id, presence: true  
end
