class FotoStock
	def guardar_stock_a_fecha
		@items_stock_a_fecha = Array.new
		deposito = Deposito.find(1) #deposito suministro "piso -1"
		@items_stock = ItemStock.where("deposito_id = ?", deposito.id)

		@items_stock.each do |item_stock|
		  item_stock_a_fecha = ItemStockAFecha.new(bien_de_consumo_id: item_stock.bien_de_consumo.id, costo: item_stock.costo_de_bien_de_consumo.costo, cantidad: item_stock.cantidad, deposito_id: item_stock.deposito.id)
		  item_stock_a_fecha.save
		  @items_stock_a_fecha << item_stock_a_fecha
		end
		@reporte_a_fecha = ReporteAFecha.new(fecha: DateTime.now, stock_diario: @items_stock_a_fecha.to_json)
		if @reporte_a_fecha.save
			Rails.logger.info("El reporte se guardó exitosamente #{Time.zone.now}")
		else
			Rails.logger.info("El reporte no pudo ser guardado #{Time.zone.now}")
		end
	end

	def test
	  puts 'hola!!!!'
	end

	def traer_lista_de_stocks
	  #@reportes = Array.new
		@items_stock = Array.new
	  ReporteAFecha.all.each do |reporte|
	    @items_de_stock_json = JSON.parse(reporte.stock_diario)
	    @items_de_stock_json.each do |item|
				# puts "************* #{item['bien_de_consumo_id'].to_i} *************"
				if item['bien_de_consumo_id'].to_i == 1715
		      item_stock_a_fecha = ItemStockAFecha.new(bien_de_consumo_id: item['bien_de_consumo_id'], deposito: Deposito.find(item['deposito_id']), costo: item['costo'], cantidad: item['cantidad'])
		      @items_stock << item_stock_a_fecha
					puts "ENTRO UNA VEZ"
					break
				else
					#puts "No entro!!!!!"
				end
	    end
			break
	  end
		return	@items_stock
	end


end
