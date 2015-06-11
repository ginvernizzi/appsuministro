class PartidaPrincipal < ActiveRecord::Base
  belongs_to :inciso
  has_many :partidas_parciales
  
  validates :inciso, presence: true

  validates_length_of :codigo, :minimum => 1, :maximum => 1, :allow_blank => false
	
	before_destroy :check_for_partidas_parciales

validates_uniqueness_of :codigo, scope: :inciso_id, :message => "de partida principal ya existe para ese Inciso"  
validates_uniqueness_of :nombre, scope: :inciso_id, :message => "de partida principal ya existe para ese Inciso"  

  private 

	def check_for_partidas_parciales
	  if self.partidas_parciales.count > 0 		
	   self.errors[:base] << "No se puede eliminar el item mientras tenga elementos asociados"
	   return false
	  end
	end  
end
