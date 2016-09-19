#encoding: utf-8
class GeneradorDeImpresionItemStock
	include ApplicationHelper
	include ActionView::Helpers::NumberHelper

  def initialize
    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
  end

	def generar_pdf(items)
		@items = items

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_items_stock.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", DateTime.now.strftime("%d/%m/%Y"))
			r.add_field("COSTO_TOTAL_GRAL", number_to_currency(obtener_total_general_de_items_stock(@items), :precision => 3))

			r.add_table("TABLA_ITEM_STOCK", @items) do |s|
				s.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre) }
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }
				s.add_column("CANTIDAD") { |i| i.cantidad.to_i }
				s.add_column("COSTO") { |i| number_to_currency(i.costo_de_bien_de_consumo.costo , :precision => 3) }
				s.add_column("COSTO_TOTAL") { |i| number_to_currency(i.costo_de_bien_de_consumo.costo * i.cantidad, :precision => 3) }
				s.add_column("DEPOSITO") { |i| i.deposito.nombre }
				s.add_column("AREA") { |i| i.deposito.area.nombre }
			end
		end
		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_odt)
		report.generate(@ruta_formulario_interno_odt)
		#@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end

	def generar_pdf_stock_faltante(items)
			@items = items

			@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_items_stock_faltante.odt")

			report = ODFReport::Report.new(@ruta_plantilla) do |r|
				r.add_field("FECHA", DateTime.now.strftime("%d/%m/%Y"))
				r.add_field("COSTO_TOTAL_GRAL", number_to_currency(obtener_total_general_de_items_stock(@items), :precision => 3))

				r.add_table("TABLA_ITEM_STOCK", @items) do |s|
					s.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }
					s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre) }
					s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }
					s.add_column("CANTIDAD") { |i| i.cantidad.to_i }
					s.add_column("COSTO") { |i| number_to_currency(i.costo_de_bien_de_consumo.costo , :precision => 3) }
					s.add_column("COSTO_TOTAL") { |i| number_to_currency(i.costo_de_bien_de_consumo.costo * i.cantidad, :precision => 3) }
					s.add_column("DEPOSITO") { |i| i.deposito.nombre }
					s.add_column("AREA") { |i| i.deposito.area.nombre }
				end
			end
			@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_stock_faltante_odt)
			report.generate(@ruta_formulario_interno_odt)
			#@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
			# `libreoffice --headless --invisible --convert-to pdf --outdir #{@ruta_formularios_internos} #{@ruta_formulario_interno_odt}`
			`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end


	def nombre_formulario_pdf
		nombre_formulario + ".pdf"
	end

	def nombre_formulario_stock_faltante_pdf
		nombre_formulario_stock_faltante + ".pdf"
	end

	private

	def nombre_formulario_odt
		nombre_formulario + ".odt"
	end

	def nombre_formulario
		"comprobante_item_stock_" + @fecha_inicializacion
	end

	###############

	def nombre_formulario_stock_faltante_odt
		nombre_formulario + ".odt"
	end

	def nombre_formulario_stock_faltante
		"comprobante_item_stock_faltante" + @fecha_inicializacion
	end

end
