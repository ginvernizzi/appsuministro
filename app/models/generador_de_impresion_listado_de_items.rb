#encoding: utf-8
class GeneradorDeImpresionListadoDeItems
include ApplicationHelper 
	def initialize
		@fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
	end

	def generar_pdf_listado_de_items(items)
		@bienes = items		
		
		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_listado_de_items.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", Time.now.strftime("%d/%m/%Y"))	
			
			r.add_table("TABLA_ITEMS", @bienes, :header=>true) do |s|								
				s.add_column("CLASE") { |i| i.clase.nombre }
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.nombre) }
				s.add_column("NOMBRE") { |i| i.nombre }	
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_listado_items_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`		
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end

	def nombre_formulario_listado_items_pdf
		nombre_formulario_listado_items + ".pdf"
	end

	private

	def nombre_formulario_listado_items_odt
		nombre_formulario_listado_items + ".odt"
	end


	def nombre_formulario_listado_items
		"comprobante_listado_de_items_" + @fecha_inicializacion
	end

end
