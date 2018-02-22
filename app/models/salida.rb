class Salida
	attr_accessor :bien_de_consumo_id, :costo_recepcion, :costo_foto

	def initialize(bien_id, costo_recepcion, costo_foto)
    @bien_de_consumo_id = bien_id
    @costo_recepcion = costo_recepcion
		@costo_foto = costo_foto
  end

end
