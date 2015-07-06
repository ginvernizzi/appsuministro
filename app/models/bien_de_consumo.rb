class BienDeConsumo < ActiveRecord::Base	
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

	validates :codigo, :uniqueness => { :message => 'existente para la Clase', :scope => [:clase_id, :fecha_de_baja] }
	validates :nombre, :uniqueness => { :message => 'existente para la Clase', :scope => [:clase_id, :fecha_de_baja] }
end
