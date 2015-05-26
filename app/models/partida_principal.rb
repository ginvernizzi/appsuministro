class PartidaPrincipal < ActiveRecord::Base
  belongs_to :inciso
  has_many :partidas_parciales

  validates :nombre, presence: true , uniqueness: true
  validates :inciso, presence: true

  validates_length_of :codigo, :minimum => 1, :maximum => 1, :allow_blank => false
	
	before_destroy :check_for_partidas_parciales
  private 

	def check_for_partidas_parciales
	  if self.partidas_parciales.count > 0 		
	   self.errors[:base] << "No se puede eliminar el item mientras tenga elementos asociados"
	   return false
	  end
	end  
end
