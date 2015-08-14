#encoding: utf-8
class GeneradorDeImpresionTransferencia
include ApplicationHelper 
  def initialize
    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
  end

	def generar_pdf_transferencia(transferencia)
		@bienes = transferencia.bienes_de_consumo_para_transferir		
		
		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_transferencia.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", transferencia.fecha.strftime("%d/%m/%Y"))	
			r.add_field("AREA", transferencia.area.nombre)				
			r.add_field("NUMERO", transferencia.id)
			r.add_field("DEPOSITO", transferencia.deposito.nombre)
			
			r.add_table("TABLA_TRANSFERENCIA", @bienes, :header=>true) do |s|								
				s.add_column("CLASE") { |i| i.bien_de_consumo.nombre }
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre) }
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }
				s.add_column("AREA_ORIGEN") { |i| i.deposito.area.nombre }							
				s.add_column("DEPOSITO_ORIGEN") { |i| i.deposito.nombre }
				s.add_column("DESCRIPCION_ADICIONAL") { |i| "Traer desc arbol del bien" }							
				s.add_column("CANTIDAD") { |i| i.cantidad }				
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_transferencia_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		`libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`		
	end

	def nombre_formulario_transferencia_pdf
		nombre_formulario_transferencia + ".pdf"
	end

	private

	def nombre_formulario_transferencia_odt
		nombre_formulario_transferencia + ".odt"
	end


	def nombre_formulario_transferencia
		"comprobante_transferencia_" + @fecha_inicializacion
	end

end
