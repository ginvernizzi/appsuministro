#encoding: utf-8
class GeneradorDeImpresionItemsDeConsumo
	include ApplicationHelper
	include ActionView::Helpers::NumberHelper

	def initialize
	    @fecha_inicializacion = Time.zone.now.to_formatted_s(:number)
	end

	def generar_pdf_items_consumo_directo(bienes_de_consumo_para_consumir)
		bienes = bienes_de_consumo_para_consumir

		@ruta_plantilla = Rails.root.join("app/plantillas/formulario_comprobante_consumos_por_obra_proyecto.odt")

		report = ODFReport::Report.new(@ruta_plantilla) do |r|
			r.add_field("FECHA", I18n.l(DateTime.now))
			r.add_field("OBRA_PROYECTO", bienes[0].consumo_directo.obra_proyecto.descripcion)
			r.add_field("COSTO_TOTAL_GENERAL", obtener_total_general(bienes))

			r.add_table("TABLA_CONSUMO_DIRECTO", bienes) do |s|
				s.add_column("FECHA_CONSUMO") { |i| i.consumo_directo.fecha.strftime("%d/%m/%Y") }
				s.add_column("COMPROBANTE") { |i| i.consumo_directo.id }
				s.add_column("CLASE") { |i| i.bien_de_consumo.clase.nombre }
				s.add_column("CODIGO") { |i| obtener_codigo_completo_bien_de_consumo(i.bien_de_consumo.nombre)  }
				s.add_column("NOMBRE") { |i| i.bien_de_consumo.nombre }
				s.add_column("AREA_DESTINO") { |i| i.consumo_directo.area.nombre }
				s.add_column("CANTIDAD") { |i| i.cantidad }
				s.add_column("COSTO") { |i| number_to_currency(i.costo, precision: 3) }
				s.add_column("COSTO_TOTAL") { |i| number_to_currency(obtener_costo_total(i.costo, i.cantidad), precision: 3) }
				s.add_column("DESCRIPCION") { |i| i.descripcion_de_recepcion }
				s.add_column("SUBTOTAL") { |i| number_to_currency(i.subtotal,precision: 3) }
			end
		end

		@ruta_formulario_interno_odt = Rails.root.join("public/forms_impresiones/" + nombre_formulario_consumo_items_odt)
		report.generate(@ruta_formulario_interno_odt)
		@ruta_formularios_internos = Rails.root.join("public/forms_impresiones/")
		`unoconv -f pdf #{@ruta_formulario_interno_odt}`
	end

	def nombre_formulario_consumo_items_pdf
		nombre_formulario_consumo_items + ".pdf"
	end

	private

	def nombre_formulario_consumo_items_odt
		nombre_formulario_consumo_items + ".odt"
	end

	def nombre_formulario_consumo_items
		"comprobante_consumo_directo_items_" + @fecha_inicializacion
	end
end
