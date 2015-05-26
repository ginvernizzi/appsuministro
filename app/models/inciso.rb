class Inciso < ActiveRecord::Base
	validates :codigo, presence: true , uniqueness: true 
	validates :nombre, presence: true , uniqueness: true	

	has_many :partidas_principales

	validates_length_of :codigo, :minimum => 1, :maximum => 1, :allow_blank => false

	before_destroy :check_for_partidas_principales

	private 

	def check_for_partidas_principales
	  if self.partidas_principales.count > 0 		
	   self.errors[:base] << "No se puede eliminar el item mientras tenga elementos asociados"
	   return false
	  end
	end  
end
