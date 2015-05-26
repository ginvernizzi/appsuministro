#encoding: utf-8
class GeneradorDeImpresionRecepcion
	include ApplicationHelper 

	def initialize
	    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
	end

	def generar_pdf_recepcion(recepciones)		

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_recepcion.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", I18n.l(DateTime.now))				

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
		`libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`		
	end

	def nombre_formulario_recepcion_pdf
		nombre_formulario_recepcion + ".pdf"
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
	# def nombre_formulario_consumo_items_odt
	# 	nombre_formulario_consumo_items + ".odt"
	# end

	# def nombre_formulario_consumo_items
	# 	"comprobante_consumo_directo_items_" + @fecha_inicializacion
	# end
end
