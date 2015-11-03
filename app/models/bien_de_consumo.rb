class BienDeConsumo < ActiveRecord::Base	
	include ApplicationHelper
	
	attr_accessor :saltear_codigo_de_item_existente

	belongs_to :clase
	has_many :items_stock
	has_many :depositos
	

	has_one :reemplazo_nuevo, class_name: "ReemplazoBdc", foreign_key: "bdc_viejo_id"
  	has_one :reemplazo_viejo, class_name: "ReemplazoBdc", foreign_key: "bdc_nuevo_id"
  	has_one :bien_viejo, through: :reemplazo_viejo, source: :bdc_viejo
  	has_one :bien_nuevo, through: :reemplazo_nuevo, source: :bdc_nuevo  	


	validates :clase, presence: true 

	#validates :stock_minimo, presence: true 

	validates_length_of :codigo, :minimum => 4, :maximum => 4, :allow_blank => false	   
	validates_numericality_of :codigo, :only_integer => true, :allow_nil => true, 
    :message => "admite solo numeros."
    
    validates_numericality_of :stock_minimo, :only_integer => true, :allow_nil => true, 
    :message => "admite solo numeros."

	#validates :codigo, :uniqueness => { :message => 'existente para la Clase', :scope => [:clase_id, :fecha_de_baja] }
	validate :validar_nombre_de_item_existente, unless: :saltear_codigo_de_item_existente
	validates :nombre, :uniqueness => { :message => 'existente para la Clase', :scope => [:clase_id, :fecha_de_baja] }

	 def combinar_codigo_nombre
    "#{obtener_codigo_completo_bien_de_consumo(id)}" +" - "+ "#{nombre}"
 	 end

 	 def validar_nombre_de_item_existente
 	 	results =  self.clase.bienes_de_consumo.where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.codigo = ?", self.codigo) 
 	 	puts results.count
 	 	if results.count > 0
			errors[:codigo] << "Ya existe un item con ese código para la clase" 
		end
	end
end
