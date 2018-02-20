class ReportesAFechaController < ApplicationController
  def index
    @reportes_a_fecha = ReporteAFecha.where("fecha >= ? AND fecha <= ?", DateTime.now, DateTime.now)
  end

  def traer_items_stock
    #displaying filtered results

    if !params[:fecha_fin].empty?
      date_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day()
      @reportes_a_fecha = ReporteAFecha.where("fecha = ?", date_fin)
    else
      @reportes_a_fecha = ReporteAFecha.all
      puts 'todos!!!!'
    end

    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js {}
    end
  end

  def show
    ActiveRecord::Base.transaction do
      begin
        @reporte_a_fecha = ReporteAFecha.find(params[:id])
        @items_de_stock_json = JSON.parse(@reporte_a_fecha.stock_diario)
        @items_stock = Array.new
        @items_de_stock_json.each do |item|
          item_stock_a_fecha = ItemStockAFecha.new(
          bien_de_consumo: BienDeConsumo.find(item['bien_de_consumo_id']),
          deposito: Deposito.find(item['deposito_id']),
          costo: item['costo'],
          cantidad: item['cantidad'])

          @items_stock << item_stock_a_fecha
        end
        respond_to do |format|
          format.html { render :show }
          format.json { render json: @items_stock.errors, status: :unprocessable_entity }
      	end
      rescue Exception => e
        flash[:notice] = "#{e}. El reporte no se puede ver"
        redirect_to  reportes_a_fecha_path
      end
    end
  end

  def imprimir_formulario
    ActiveRecord::Base.transaction do
      begin
        deposito = Area.where("nombre LIKE ?", "%PATRI%").first.depositos.where("nombre ILIKE ?", "%suministro%")
        @reporte_a_fecha = ReporteAFecha.find(params[:id])
        @items_de_stock_json = JSON.parse(@reporte_a_fecha.stock_diario)

        @items_stock = Array.new
        @items_de_stock_json.each do |item|
            item_stock_a_fecha = ItemStockAFecha.new(
            bien_de_consumo: BienDeConsumo.find(item['bien_de_consumo_id']),
            deposito: Deposito.find(item['deposito_id']),
            costo: item['costo'],
            cantidad: item['cantidad'])
            @items_stock << item_stock_a_fecha
        end
        @generador = GeneradorDeImpresionStockAFecha.new
        @generador.generar_pdf(@reporte_a_fecha.fecha, @items_stock)
        file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
        send_file ( file )
      rescue Exception => e
        flash[:notice] = "#{e}. El reporte no será impreso."
        redirect_to  reportes_a_fecha_path
      end
    end
  end
end
