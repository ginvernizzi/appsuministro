#encoding: utf-8
class GeneradorDeImpresion
	include ApplicationHelper 
	include ActionView::Helpers::NumberHelper

	def initialize
	    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
	end

	def generar_pdf(recepcion)
		@bienes = recepcion.bienes_de_consumo_de_recepcion		

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_ingreso_a_stock.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", I18n.l(recepcion.fecha))				

			r.add_table("TABLA_ITEM_STOCK", @bienes, :header=>true) do |s|
				s.add_column("TIPO_DOC_PPAL") { recepcion.documento_principal.documento_de_recepcion.tipo_de_documento.nombre }
				s.add_column("NUMERO_DOC_PPAL") { recepcion.documento_principal.documento_de_recepcion.numero_de_documento }
				s.add_column("NUMERO_RECECPCION") { recepcion.id }
				s.add_column("CODIGO") { |i| i.bien_de_consumo.codigo }
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }							
				s.add_column("CANTIDAD") { |i| i.cantidad }
				s.add_column("COSTO") { |i| number_to_currency(i.costo, :precision => 3) } 
				s.add_column("TOTAL") { |i| number_to_currency((i.costo * i.cantidad), :precision => 3)  }				
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`			
	end

	def generar_pdf_consumo_directo(consumo)
		@bienes = consumo.bienes_de_consumo_para_consumir		

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_consumo_directo.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", consumo.fecha.strftime("%d/%m/%Y"))	
			r.add_field("AREA", consumo.area.nombre)				
			r.add_field("NUMERO", consumo.id)
			r.add_field("OBRAPROYECTO", consumo.obra_proyecto.descripcion)
			

			r.add_table("TABLA_CONSUMO_DIRECTO", @bienes, :header=>true) do |s|								
				s.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }							
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre) }
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }							
				s.add_column("DESCRIPCION_ADICIONAL") { |i| i.bien_de_consumo.detalle_adicional }							
				s.add_column("CANTIDAD") { |i| i.cantidad }				
				s.add_column("COSTO") { |i| number_to_currency(i.costo, :precision => 3) }	
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_consumo_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`			
	end

	def generar_pdf_items_consumo_directo(bienes_de_consumo_para_consumir)
		bienes = bienes_de_consumo_para_consumir		

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_consumo_directo_items.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", I18n.l(DateTime.now))
			r.add_field("AREA", bienes[0].deposito.area.nombre)
								
			r.add_table("TABLA_CONSUMO_DIRECTO", bienes, :header=>true) do |s|								
				s.add_column("FECHA_CONSUMO") { |i| i.consumo_directo.fecha.strftime("%d/%m/%Y") }
				s.add_column("COMPROBANTE") { |i| i.consumo_directo.id }							
				s.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }							
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre)  }							
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }				
				s.add_column("OBRA_PROYECTO") { |i| i.consumo_directo.obra_proyecto.descripcion }							
				s.add_column("CANTIDAD") { |i| i.cantidad }				
			end
		end

		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_consumo_items_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`						
	end


	def nombre_formulario_pdf
		nombre_formulario + ".pdf"
	end

	def nombre_formulario_consumo_pdf
		nombre_formulario_consumo + ".pdf"
	end

	######
	def nombre_formulario_consumo_items_pdf
		nombre_formulario_consumo_items + ".pdf"
	end

	private

	def nombre_formulario_odt
		nombre_formulario + ".odt"
	end

	def nombre_formulario
		"comprobante_ingreso_a_stock_" + @fecha_inicializacion
	end

	############

	def nombre_formulario_consumo_odt
		nombre_formulario_consumo + ".odt"
	end

	def nombre_formulario_consumo
		"comprobante_consumo_directo_" + @fecha_inicializacion
	end

	############
	def nombre_formulario_consumo_items_odt
		nombre_formulario_consumo_items + ".odt"
	end

	def nombre_formulario_consumo_items
		"comprobante_consumo_directo_items_" + @fecha_inicializacion
	end
end
