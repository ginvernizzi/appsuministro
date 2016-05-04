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
end