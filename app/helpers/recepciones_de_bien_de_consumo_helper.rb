module RecepcionesDeBienDeConsumoHelper
	def genero_un_consumo_directo?(id)
    	RecepcionParaConsumoDirecto.all.any? {|h| h.recepcion_de_bien_de_consumo.id == id } 
   	end
end
