class PartidaParcial < ActiveRecord::Base
  belongs_to :partida_principal    

  has_many :clases, -> { where("clases.fecha_de_baja IS NULL") }
    
  validates :partida_principal, presence: true

  validates_length_of :codigo, :minimum => 1, :maximum => 1, :allow_blank => false

  validates_length_of :codigo, :minimum => 1, :maximum => 1, :allow_blank => false

  before_destroy :check_for_clases

  validates_uniqueness_of :codigo, scope: :partida_principal_id, :message => "de partida parcial ya existe para esa partida principal"  
  validates_uniqueness_of :nombre, scope: :partida_principal_id, :message => "de partida parcial ya existe para esa partida principal"  

  private 

  def check_for_clases
  	if self.clases.any?  		
 	    self.errors[:base] << "No se puede eliminar el item mientras tenga elementos asociados"
      return false
  	end
  end  
end
