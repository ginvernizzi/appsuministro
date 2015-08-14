class Clase < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :partida_parcial

  has_many :bienes_de_consumo, -> { where("bienes_de_consumo.fecha_de_baja IS NULL") }


  has_one :reemplazo_nuevo, class_name: "ReemplazoClase", foreign_key: "clase_vieja_id"
  has_one :reemplazo_viejo, class_name: "ReemplazoClase", foreign_key: "clase_nueva_id"
  has_one :clase_vieja, through: :reemplazo_viejo, source: :clase_vieja
  has_one :clase_nueva, through: :reemplazo_nuevo, source: :clase_nueva    


  validates :codigo, presence: true
  validates :nombre, presence: true 

  validates :partida_parcial, presence: true 
  
  validates_length_of :codigo, :minimum => 5, :maximum => 5, :allow_blank => false
  validates_numericality_of :codigo, :only_integer => true, :allow_nil => true, 
    :message => "admite solo numeros."  

  validates :codigo, :uniqueness => {:message => 'existente para la Partida Parcial', :scope => [:partida_parcial_id, :fecha_de_baja] }
  validates :nombre, :uniqueness => {:message => 'existente para la Partida Parcial', :scope => [:partida_parcial_id, :fecha_de_baja] }  
  
  before_destroy :check_for_bienes_de_consumo

	def tiene_items_asociados
	  if self.bienes_de_consumo.count > 0 		
	   self.errors[:base] << "No se puede dar de baja el item mientras tenga elementos asociados"
	   return true
	  end
	end 

  def combinar_codigo_nombre
    " #{obtener_codigo_de_clase(id)}" +" - "+ "#{nombre}"
  end 
end
