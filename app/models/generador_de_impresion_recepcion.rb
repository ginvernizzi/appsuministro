#encoding: utf-8
class GeneradorDeImpresionRecepcion
	include ApplicationHelper 
	include ActionView::Helpers::NumberHelper

	def initialize
	    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
	end

	def generar_pdf_recepcion(recepciones)		

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_recepcion.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", DateTime.now.strftime("%d/%m/%Y"))				

			r.add_table("TABLA_RECEPCIONES", recepciones, :header=>true) do |s|
				s.add_column("NUMERO") { |i| i.id }
				s.add_column("FECHA") { |i| i.fecha }
				s.add_column("TIPO_DE_DOCUMENTO") { |i| i.documento_principal.documento_de_recepcion.tipo_de_documento.nombre }
				s.add_column("DOCUMENTO_PRINCIPAL") { |i| i.documento_principal.documento_de_recepcion.numero_de_documento }				
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_recepcion_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`		
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end

	def generar_pdf_detalle_de_recepcion(recepcion)		

		@bienes = recepcion.bienes_de_consumo_de_recepcion

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_detalle_de_recepcion.odt")		

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", DateTime.now.strftime("%d/%m/%Y"))				
			r.add_field("NUMERO_DE_RECEPCION",recepcion.id )				
			r.add_field("FECHA_DE_RECEPCION", recepcion.fecha.strftime("%d/%m/%Y") )				
			r.add_field("ESTADO",RecepcionDeBienDeConsumo::ESTADOS.key(recepcion.estado))				
			r.add_field("DESCRIPCION_PROVISORIA", recepcion.descripcion_provisoria)																				  

			r.add_field("TIPO", recepcion.documento_principal.documento_de_recepcion.tipo_de_documento.nombre)										
			r.add_field("DOCUMENTO_PRINCIPAL", recepcion.documento_principal.documento_de_recepcion.numero_de_documento)										

			r.add_field("TOTAL_GENERAL", number_to_currency(obtener_total_general_de_bienes_de_consumo(recepcion.bienes_de_consumo_de_recepcion), :precision => 3))										

			r.add_table("TABLA_DOCUMENTOS_SECUNDARIOS", recepcion.documentos_secundario, :header=>true) do |r|
				r.add_column("TIPO_SECUNDARIO") { |i| i.documento_de_recepcion.tipo_de_documento.nombre  }
				r.add_column("DOCUMENTO_SECUNDARIO") { |i| i.documento_de_recepcion.numero_de_documento }				
			end

			r.add_table("TABLA_BIENES", @bienes, :header=>true) do |r|			
				r.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }							
				r.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre)  }
				r.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }							
				r.add_column("CANTIDAD") { |i| i.cantidad }
				r.add_column("COSTO") { |i| number_to_currency(i.costo, :precision => 3) }									
				r.add_column("COSTO_TOTAL") { |i| number_to_currency(i.costo * i.cantidad, :precision => 3)  }
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_detalle_de_recepcion_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`		
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end

	def nombre_formulario_recepcion_pdf
		nombre_formulario_recepcion + ".pdf"
	end

	def nombre_formulario_detalle_de_recepcion_pdf
		nombre_formulario_detalle_de_recepcion + ".pdf"
	end

	######
	
	# def nombre_formulario_consumo_items_pdf
	# 	nombre_formulario_consumo_items + ".pdf"
	# end

	private


	def nombre_formulario_recepcion_odt
		nombre_formulario_recepcion + ".odt"
	end

	def nombre_formulario_recepcion
		"comprobante_recepcion_" + @fecha_inicializacion
	end

	############

	def nombre_formulario_detalle_de_recepcion_odt
		nombre_formulario_detalle_de_recepcion + ".odt"
	end

	def nombre_formulario_detalle_de_recepcion
		"comprobante_detalle_de_recepcion_" + @fecha_inicializacion
	end
	# def nombre_formulario_consumo_items_odt
	# 	nombre_formulario_consumo_items + ".odt"
	# end

	# def nombre_formulario_consumo_items
	# 	"comprobante_consumo_directo_items_" + @fecha_inicializacion
	# end
end
