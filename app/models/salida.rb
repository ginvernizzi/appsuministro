class Salida
	attr_accessor :fecha, :foto_id, :bien_de_consumo_id, :costo_recepcion, :costo_foto

	def initialize(fecha, foto_id, bien_id, costo_recepcion, costo_foto)
		@fecha = fecha
		@foto_id = foto_id
    @bien_de_consumo_id = bien_id
    @costo_recepcion = costo_recepcion
		@costo_foto = costo_foto
  end

end
