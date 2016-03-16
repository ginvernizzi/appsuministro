#encoding: utf-8
class GeneradorDeImpresionSeguimientoSalidas
	include ApplicationHelper 

	def initialize
	    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
	end

	def generar_pdf_items_seguimiento_de_salidas(bienes_de_consumo_para_consumir)
		@bienes = bienes_de_consumo_para_consumir		

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_items_seguimiento_de_salidas.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", I18n.l(DateTime.now))														

			r.add_table("TABLA_SEGUIMIENTO_DE_SALIDA", @bienes, :header=>true) do |s|	
				s.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }								
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre)  }							
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }	
				s.add_column("CANTIDAD") { |i| i.cantidad }					
				
				s.add_column("FECHA_SALIDA") { |i| 
					if i.respond_to?(:consumo_directo) 
						i.consumo_directo.fecha.strftime("%d/%m/%Y") 
					else 
						i.transferencia.fecha.strftime("%d/%m/%Y") 
					end }

				s.add_column("COMPROBANTE") { |i| 
					if i.respond_to?(:consumo_directo) 
						i.consumo_directo.id 
					else 
						i.transferencia.id 
					end }

				s.add_column("DESTINO") { |i| 
					if i.respond_to?(:consumo_directo) 
						i.consumo_directo.area.nombre 
					else 
						i.transferencia.deposito.nombre 
					end }

				s.add_column("OPERACION") { |i| 
					if i.respond_to?(:consumo_directo)
				 		"Consumo" 
					else 
						"Transferencia"
					end }																									
			end													
		end

		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_seguimiento_salidas_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`					
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end

	######
	def nombre_formulario_seguimiento_salidas_pdf
		nombre_formulario_seguimiento_salidas + ".pdf"
	end

	private

	def nombre_formulario_seguimiento_salidas_odt
		nombre_formulario_seguimiento_salidas + ".odt"		
	end

	def nombre_formulario_seguimiento_salidas
		"comprobante_seguimiento_salidas_" + @fecha_inicializacion
	end		
end
