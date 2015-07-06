class ReemplazoBdc < ActiveRecord::Base
	belongs_to :bdc_viejo, class_name: "BienDeConsumo"
	belongs_to :bdc_nuevo, class_name: "BienDeConsumo"
	
  	validates :bdc_viejo, :presence => { message: ":debe seleccionar el item dado de baja" }
  	validates :bdc_nuevo, :presence => { message: ":debe seleccionar el item dado de alta" }
end
