class FotoStock
	def guardar_stock_a_fecha
		@items_stock_a_fecha = Array.new
		deposito = Deposito.find(1) #deposito suministro "piso -1"
		@items_stock = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("deposito_id = ?", deposito.id).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")

		@items_stock.each do |item_stock|
		  item_stock_a_fecha = ItemStockAFecha.new(bien_de_consumo_id: item_stock.bien_de_consumo.id, costo: item_stock.traer_ultimo_costo_de_bien_de_consumo, cantidad: item_stock.cantidad, deposito_id: item_stock.deposito.id)
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

	def get_historial(bien_de_consumo_id_a_buscar, desde, hasta)
			fecha_desde = desde.to_date
			fecha_hasta = hasta.to_date
			puts fecha_desde
			puts fecha_hasta

			@items_stock = Array.new
		  ReporteAFecha.all.each do |reporte|
					if reporte.fecha.to_date  > fecha_desde &&  reporte.fecha.to_date < fecha_hasta
						  @items_de_stock_json = JSON.parse(reporte.stock_diario)
						  @items_de_stock_json.each do |item|
									if item['bien_de_consumo_id'].to_i == bien_de_consumo_id_a_buscar
											puts "Entre"
								      #item_stock_a_fecha = ItemStockAFecha.new(bien_de_consumo_id: item['bien_de_consumo_id'], deposito: Deposito.find(item['deposito_id']), costo: item['costo'], cantidad: item['cantidad'])
								      #@items_stock << item_stock_a_fecha
											puts "Costo :  #{item['costo']}"
											puts "Cantidad :  #{item['cantidad']}"
											break;
									end
						  end
					end
		  end
			return
			#return	@items_stock
	end

	def traer_registros_de_stock_con_errores
		@salida = Array.new
		RecepcionDeBienDeConsumo.where("fecha IS NOT NULL AND estado <> ? AND estado <> ?", 7, 4).find_each(batch_size: 50) do |recepcion|
			@reporte_a_fecha = ReporteAFecha.where("fecha = ?", recepcion.fecha).last	#Traigo el ultimo foto de stock para la fecha de la rececpion
			if !@reporte_a_fecha.nil?
				@items_de_stock_json = JSON.parse(@reporte_a_fecha.stock_diario)
				recepcion.bienes_de_consumo_de_recepcion.each do |item|
					@costo_de_bien_de_consumo = @items_de_stock_json.select {|h1| h1["bien_de_consumo_id"] == item.bien_de_consumo_id }
					if !@costo_de_bien_de_consumo.blank?
						@costo_foto = @costo_de_bien_de_consumo.first["costo"]
						if item.costo != @costo_foto.to_d
							@registro = Salida.new(recepcion.fecha, @reporte_a_fecha.id ,item.bien_de_consumo_id, item.costo, @costo_foto.to_d)
							@salida << @registro
						end
					end
				end
			end
		end

		@salida.each do |item|
			puts "bien id: #{item.bien_de_consumo_id} | costo_recepcion: #{item.costo_recepcion} | costo foto: #{item.costo_foto}"
		end
		puts "cantidad: #{@salida.count}"
	end

end
