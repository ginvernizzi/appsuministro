#encoding: utf-8
class GeneradorDeImpresionStockAFecha
  include ApplicationHelper 
  def initialize
    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
  end

	def generar_pdf(fecha, items)
		@items = items

		deposito_array = Deposito.where("nombre like ?", "%-1%") #deposito -1, de area suministro
		deposito = Deposito.find(deposito_array[0].id)

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_stock_a_fecha.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", fecha.strftime("%d/%m/%Y"))				
			r.add_field("AREA", deposito.area.nombre)
			r.add_field("DEPOSITO", deposito.nombre)

			r.add_table("TABLA_ITEM_STOCK", @items, :header=>true) do |s|				
				s.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }							
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre) }
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }							
				s.add_column("CANTIDAD") { |i| i.cantidad }
				s.add_column("COSTO") { |i| number_to_currency(i.costo, :precision => 3) }				
				s.add_column("COSTO TOTAL") { |i| number_to_currency(i.costo * i.cantidad, :precision => 3) }				
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`		
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end


	def nombre_formulario_pdf
		nombre_formulario + ".pdf"
	end

	private

	def nombre_formulario_odt
		nombre_formulario + ".odt"
	end

	def nombre_formulario
		"stock_de_bienes_a_fecha_" + @fecha_inicializacion
	end

end
