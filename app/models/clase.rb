class Clase < ActiveRecord::Base
  belongs_to :partida_parcial

  has_many :bienes_de_consumo

  validates :codigo, presence: true
  validates :nombre, presence: true 

  validates :partida_parcial, presence: true 
  
  validates_length_of :codigo, :minimum => 5, :maximum => 5, :allow_blank => false
  validates_numericality_of :codigo, :only_integer => true, :allow_nil => true, 
    :message => "admite solo numeros."

  validates_uniqueness_of :codigo, scope: :partida_parcial_id, :message => "de clase ya existe para esa partida parcial"  
  validates_uniqueness_of :nombre, scope: :partida_parcial_id, :message => "de clase ya existe para esa partida parcial"  

  before_destroy :check_for_bienes_de_consumo
  private 

	def check_for_bienes_de_consumo
	  if self.bienes_de_consumo.count > 0 		
	   self.errors[:base] << "No se puede eliminar el item mientras tenga elementos asociados"
	   return false
	  end
	end  

end
