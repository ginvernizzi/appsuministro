class ReemplazoClase < ActiveRecord::Base
	belongs_to :clase_vieja, class_name: "Clase"
	belongs_to :clase_nueva, class_name: "Clase"
	
	validates :clase_vieja, :presence => { message: ":debe seleccionar la clase dada de baja" }
	validates :clase_nueva, :presence => { message: ":debe seleccionar la clase dada de alta" }
end
