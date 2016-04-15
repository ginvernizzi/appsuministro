module ConsumoDirectosHelper  
    def consumo_desde_recepcion?(id)
    	RecepcionParaConsumoDirecto.all.any? {|h| h.consumo_directo.id == id } 
   	end
end
