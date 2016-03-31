#encoding: utf-8
class GeneradorDeImpresionListadoDeClases
include ApplicationHelper 
include ActionView::Helpers::NumberHelper
	def initialize
		@fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
	end

	def generar_pdf_listado_de_clases(clases)
		@clases = clases		
		
		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_listado_de_clases.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", Time.now.strftime("%d/%m/%Y"))	
			
			r.add_table("TABLA_ITEMS", @clases, :header=>true) do |s|								
				s.add_column("PARTIDA_PARCIAL") { |i| i.partida_parcial.nombre }
				s.add_column("CODIGO") { |i| obtener_codigo_de_clase(i.id) }
				s.add_column("NOMBRE") { |i| i.nombre }	
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_listado_clases_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`		
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end

	def nombre_formulario_listado_clases_pdf
		nombre_formulario_listado_clases + ".pdf"
	end

	private

	def nombre_formulario_listado_clases_odt
		nombre_formulario_listado_clases + ".odt"
	end


	def nombre_formulario_listado_clases
		"comprobante_listado_de_clases_" + @fecha_inicializacion
	end

end
