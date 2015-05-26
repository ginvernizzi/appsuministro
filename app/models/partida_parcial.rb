class PartidaParcial < ActiveRecord::Base
  belongs_to :partida_principal    

  has_many :clases
  
  validates :nombre, presence: true , uniqueness: true
  validates :partida_principal, presence: true

  validates_length_of :codigo, :minimum => 1, :maximum => 1, :allow_blank => false

  validates_length_of :codigo, :minimum => 1, :maximum => 1, :allow_blank => false

  before_destroy :check_for_clases

  private 

  def check_for_clases
  	if self.clases.any?  		
 	  self.errors[:base] << "No se puede eliminar el item mientras tenga elementos asociados"
      return false
  	end
  end  
end
