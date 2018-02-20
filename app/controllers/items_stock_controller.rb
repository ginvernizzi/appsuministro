class ItemsStockController < ApplicationController

  #autocomplete :bien_de_consumo, :nombre , :full => true, :extra_data => [:codigo]
  autocomplete :area, :nombre , :full => true

  def autocomplete_bien_de_consumo_nombre
    respond_to do |format|
      @bienes = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.nombre ILIKE ?", "%#{params[:term]}%").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
      render :json => @bienes.map { |bien| {:id => bien.id, :value => bien.nombre} }
      format.js { }
    end
  end

  #no es necesaria la vista, este metodo está para que traiga por todos los items la primera vez que carga.
  def index
    date_inicio = DateTime.new(1980,1,1)
    date_fin =  DateTime.now
    @items_sin_paginar = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND items_stock.created_at BETWEEN ? AND ?", date_inicio, date_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
    @items_stock = @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)

    if !@items_stock.blank? && @items_stock.count > 0
      @items_stock[0].fecha_inicio_impresion = date_inicio;
      @items_stock[0].fecha_fin_impresion = date_fin;
      @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_sin_paginar), :precision => 3)
    end
    @action_destino = "index"
  end

  def ver_stock_con_subtotal_por_pp
    @items_stock = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")

    if !@items_stock.blank? && @items_stock.count > 0
      @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_stock), :precision => 3)
      @subtotales = traer_subtotales_de_stock_por_pp(@items_stock)

      @item_stock_obj = ItemStock.new
      @items_stock = @item_stock_obj.lista_final_con_subtotales(@items_stock, @subtotales)
      @items_stock = @items_stock.paginate(:page => params[:page], :per_page => 30)
    end

    @action_destino = "ver_stock_con_subtotal_por_pp"
  end

  def traer_stock_total_con_subtotal_por_pp
    date_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()
    date_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day()

    @items_stock = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")

    if !@items_stock.blank? && @items_stock.count > 0
      @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_stock), :precision => 3)

      @subtotales = traer_subtotales_de_stock_por_pp(@items_stock)


      @item_stock_obj = ItemStock.new
      @items_stock = @item_stock_obj.lista_final_con_subtotales(@items_stock, @subtotales)
      @items_stock = @items_stock.paginate(:page => params[:page], :per_page => 30)

      @items_stock[0].fecha_inicio_impresion = date_inicio;
      @items_stock[0].fecha_fin_impresion = date_fin;
    end

    @action_destino = "ver_stock_con_subtotal_por_pp"

  end

  def traer_subtotales_de_stock_por_pp(items_de_stock)
    lista = Array.new
    sumar_total = 0
    pp_actual = obtener_codigo_de_partida_parcial(items_de_stock.first.bien_de_consumo.clase.partida_parcial.id)
    cantidad_pp = 0

    items_de_stock.each do |item|
        if pp_actual == obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id)
            sumar_total = sumar_total + (item.cantidad * item.traer_ultimo_costo_de_bien_de_consumo)
            cantidad_pp = cantidad_pp + 1

            if(item.id == items_de_stock.last.id)
                subtotal_por_pp = Subtotal_de_stock_por_pp.new
                subtotal_por_pp.partida_parcial = pp_actual
                subtotal_por_pp.subtotal = sumar_total
                subtotal_por_pp.cantidad_pp = cantidad_pp
                lista << subtotal_por_pp
            end
        else
            subtotal_por_pp = Subtotal_de_stock_por_pp.new
            subtotal_por_pp.partida_parcial = pp_actual
            subtotal_por_pp.subtotal = sumar_total
            subtotal_por_pp.cantidad_pp = cantidad_pp
            lista << subtotal_por_pp

            sumar_total = 0
            cantidad_pp = 0

            pp_actual = obtener_codigo_de_partida_parcial(item.bien_de_consumo.clase.partida_parcial.id)
            sumar_total = sumar_total + (item.cantidad * item.traer_ultimo_costo_de_bien_de_consumo)
            cantidad_pp = cantidad_pp + 1
        end
    end
    return lista
  end

  def new
    @item_stock = ItemStock.new
    @costo = CostoDeBienDeConsumo.new
  end

  def traer_todos_los_items_stock
    respond_to do |format|
      @items_sin_paginar = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
      @items_stock = @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)

      @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_sin_paginar), :precision => 3)
      format.js {}
    end
  end

  def traer_items_stock_por_bien_y_area
    bien_de_consumo_id = params[:bien_de_consumo_id]
    area_id = Area.where("nombre LIKE ?", "%PATRI%").first.id
    @items_stock = ItemStock.joins(:deposito).where("bien_de_consumo_id = ? AND depositos.area_id = ?", bien_de_consumo_id, area_id).paginate(:page => params[:page], :per_page => 30)


    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js {}
    end
  end

  def traer_items_stock_por_fecha_bien_y_area_suministro
    area_id = Area.where("nombre LIKE ?", "%PATRI%").first.id

    codigo_pp = params[:partida_parcial]
    bien_de_consumo_id = params[:bien_de_consumo_id]
    date_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()
    date_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day()

    @items_stock = ItemStock.where("bien_de_consumo_id = ?", -1)

    if !bien_de_consumo_id.blank? && codigo_pp.blank?
      puts "******* solo bien de consumo**********"
      @items_sin_paginar = ItemStock.joins(:deposito, :bien_de_consumo).where("bienes_de_consumo.fecha_de_baja IS NULL AND bien_de_consumo_id = ? AND depositos.area_id = ? AND items_stock.created_at BETWEEN ? AND ?", bien_de_consumo_id, area_id, date_inicio, date_fin)
      @items_stock = @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)
    elsif bien_de_consumo_id.blank? && !codigo_pp.blank?
      puts "******* solo parcial**********"
      inciso = codigo_pp[0].to_s
      ppal = codigo_pp[1].to_s
      pparcial = codigo_pp[2].to_s
      @items_sin_paginar = ItemStock.joins(:deposito, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND incisos.codigo = ? AND partidas_principales.codigo = ? AND partidas_parciales.codigo = ? AND depositos.area_id = ? AND items_stock.created_at BETWEEN ? AND ?", inciso, ppal, pparcial, area_id, date_inicio, date_fin)
      @items_stock = @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)
    elsif  bien_de_consumo_id.blank? && codigo_pp.blank?
      puts "******* solo fecha **********"
      @items_sin_paginar = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND items_stock.created_at BETWEEN ? AND ?", date_inicio, date_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
      @items_stock = @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)
    end

    if !@items_stock.blank? && @items_stock.count > 0
      @items_stock[0].fecha_inicio_impresion = date_inicio;
      @items_stock[0].fecha_fin_impresion = date_fin;
      @items_stock[0].area_id_impresion = area_id;
      @items_stock[0].bien_id_impresion = bien_de_consumo_id;
      @items_stock[0].partida_parcial_impresion = codigo_pp;

      @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_sin_paginar), :precision => 3)
      @action_destino = "index"
    end

    respond_to do |format|
      format.js {}
    end
  end

  def ver_ingresar_a_stock
	  @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_id])
	  @areas = Area.all.order(:nombre)
	  @depositos = Deposito.all
	  @item_stock = ItemStock.new
  end

  def ingresar_bienes_a_stock_manualmente
    ActiveRecord::Base.transaction do
      begin
        deposito_id = 1 #>>>>>>>>>>>>>>>>> DEPOSITO SUMINISTRO -1 >>>>>>>>>>>>>>>>>
        @deposito = Deposito.find(deposito_id)
        #@bien_de_consumo = BienDeConsumo.find(item_stock_params[:bien_de_consumo_id])
        @item_stock = ItemStock.new

        @costo = guardar_costo_manualmente(item_stock_params[:bien_de_consumo_id], params[:costo])
        @costo_historico =  guardar_costo_historico(item_stock_params[:bien_de_consumo_id], params[:costo])

        @item_stock_array = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", item_stock_params[:bien_de_consumo_id], @deposito.id)

        respond_to do |format|
            @registro_ingreso_manual = RegistroIngresoManual.new(bien_de_consumo_id: item_stock_params[:bien_de_consumo_id], cantidad: item_stock_params[:cantidad], costo: params[:costo], deposito: @deposito, usuario: current_user.name)
            raise ActiveRecord::rollback unless @registro_ingreso_manual.save
            raise ActiveRecord::rollback unless @costo.save
            if @item_stock_array.count == 0  #si no hay STOCK
                @item_stock = ItemStock.new(bien_de_consumo_id: item_stock_params[:bien_de_consumo_id], cantidad: item_stock_params[:cantidad], costo_de_bien_de_consumo: @costo, deposito: @deposito)
                if @item_stock.save
                    raise ActiveRecord::rollback unless @costo_historico.save
                    format.html { redirect_to new_item_stock_path, notice: 'Los bienes fueron agregados a stock exitosamente.' }
                else
                    puts "***03******"
                    format.html { render :new }
                    format.json { render json: @item_stock.errors, status: :unprocessable_entity }
                end
            else
                @item_stock = ItemStock.find(@item_stock_array[0].id)
                if @item_stock.update(cantidad: item_stock_params[:cantidad], costo_de_bien_de_consumo: @costo )
                    puts "***04******"
                    format.html { redirect_to new_item_stock_path, notice: 'Los bienes fueron agregados a stock exitosamente.' }
                else
                    puts "***05******"
                    format.html { render :new }
                    format.json { render json: @item_stock.errors, status: :unprocessable_entity }
                end
            end
        end
      rescue ActiveRecord::Rollback
          respond_to do |format|
            format.html { render :new }
            format.json { render json: @item_stock.errors, status: :unprocessable_entity }
          end
      end
    end
  end

  #Realiza las operaciones pertinentes al hacer un ingreso a stock de los items de una recepcion
  def create
    @recepcion = RecepcionDeBienDeConsumo.find(params[:recepciones_de_bien_de_consumo_a_evaluar_id])
    areaArray = Area.where(id: 1)

    ActiveRecord::Base.transaction do
      begin
        respond_to do |format|
          if areaArray.count > 0 && areaArray[0].depositos.count > 0

              @deposito = areaArray[0].depositos.first

              @recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|

                costo_de_bien = guardar_costos(bdcdr)

                @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr.bien_de_consumo.id, @deposito.id)

                if @item_stock[0]
                  suma = @item_stock[0].cantidad + bdcdr.cantidad
                  raise ActiveRecord::Rollback unless @item_stock[0].update(cantidad: suma)
                else
                  @item_stock = ItemStock.new(bien_de_consumo: bdcdr.bien_de_consumo, cantidad: bdcdr.cantidad, costo_de_bien_de_consumo: costo_de_bien, deposito: @deposito)
                  raise ActiveRecord::Rollback unless @item_stock.save
                end
              end
              raise ActiveRecord::Rollback unless @recepcion.update(estado: "8")
              @recepcion_en_stock = RecepcionEnStock.create!(recepcion_de_bien_de_consumo: @recepcion)
              raise ActiveRecord::Rollback unless @recepcion_en_stock.save

              flash[:notice] = 'Los bienes fueron agregados a stock exitosamente.'
          else
              flash[:notice] = 'No hay area de suministro cargada, o deposito en la misma. No se podra agergar a stock'
          end
          format.html { redirect_to recepciones_de_bien_de_consumo_a_evaluar_index_path }
        end
      rescue ActiveRecord::Rollback
         respond_to do |format|
          flash[:notice] = 'Ha ocurrido un error. Los items no fueron ingresados a stock'
          format.html { redirect_to recepciones_de_bien_de_consumo_a_evaluar_index_path }
        end
      end #begin
    end #transaction
  end

  def imprimir_formulario
    @recepcion = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])
    @generador = GeneradorDeImpresion.new
    @generador.generar_pdf(@recepcion)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )
  end

  def imprimir_formulario_stock_total_con_subtotal_por_pp
    @items_stock = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND cantidad > 0").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")

    if !@items_stock.blank? && @items_stock.count > 0
      @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_stock), :precision => 3)

      @subtotales = traer_subtotales_de_stock_por_pp(@items_stock)

      @item_stock_obj = ItemStock.new
      @items_stock = @item_stock_obj.lista_final_con_subtotales(@items_stock, @subtotales)
    end

    @generador = GeneradorDeImpresionItemStock.new
    @generador.generar_pdf_stock_total_con_subtotal_por_pp(@items_stock)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )
  end


  def imprimir_formulario_stock_total_por_bien_y_area
    bien_de_consumo_id = params[:bien_id]
    area_id = params[:area_id]
    date_fin = params[:fecha_fin]
    date_inicio = params[:fecha_inicio]
    codigo_pp = params[:partida_parcial]

    @items = @items_stock = ItemStock.where("bien_de_consumo_id = ?", -1)

    if !bien_de_consumo_id.blank? && codigo_pp.blank?
      puts "******* solo bien de consumo**********"
      @items_sin_paginar = ItemStock.joins(:deposito, :bien_de_consumo).where("cantidad > 0 AND bienes_de_consumo.fecha_de_baja IS NULL AND bien_de_consumo_id = ? AND depositos.area_id = ? AND items_stock.created_at BETWEEN ? AND ?", bien_de_consumo_id, area_id, date_inicio, date_fin)
      @items_stock = @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)
    elsif bien_de_consumo_id.blank? && !codigo_pp.blank?
      puts "******* solo parcial**********"
      inciso = codigo_pp[0].to_s
      ppal = codigo_pp[1].to_s
      pparcial = codigo_pp[2].to_s
      @items_sin_paginar = ItemStock.joins(:deposito, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("cantidad > 0 AND bienes_de_consumo.fecha_de_baja IS NULL AND incisos.codigo = ? AND partidas_principales.codigo = ? AND partidas_parciales.codigo = ? AND depositos.area_id = ? AND items_stock.created_at BETWEEN ? AND ?", inciso, ppal, pparcial, area_id, date_inicio, date_fin)
      @items_stock =  @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)
    elsif  bien_de_consumo_id.blank? && codigo_pp.blank?
      puts "******* solo fecha **********"
      @items_sin_paginar = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("cantidad > 0 AND bienes_de_consumo.fecha_de_baja IS NULL AND items_stock.created_at BETWEEN ? AND ?", date_inicio, date_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
      @items_stock = @items_sin_paginar.paginate(:page => params[:page], :per_page => 30)
    end

    if !@items_sin_paginar.blank? && @items_sin_paginar.count > 0
      @items_sin_paginar[0].fecha_inicio_impresion = params[:fecha_inicio].to_date.strftime("%d/%m/%Y")
      @items_sin_paginar[0].fecha_fin_impresion = params[:fecha_fin].to_date.strftime("%d/%m/%Y")
    end

    @generador = GeneradorDeImpresionItemStock.new
    @generador.generar_pdf(@items_sin_paginar)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )
  end


  def imprimir_formulario_stock_total_todos_los_bienes
    @generador = GeneradorDeImpresionItemStock.new
    @items = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND cantidad > 0").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
    @generador.generar_pdf(@items)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )
  end


  def traer_items_stock_minimo_superado
    @items_stock = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo").paginate(:page => params[:page], :per_page => 30)
    @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_stock), :precision => 3)

    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js {}
    end
  end

  def imprimir_formulario_stock_faltante
    bien_de_consumo_id = params[:bien_id]
    area_id = params[:area_id]

    if !bien_de_consumo_id.nil? && !area_id.nil?
      @items_stock = ItemStock.joins(:bien_de_consumo,:deposito).where("bien_de_consumo_id = ? AND depositos.area_id = ? AND cantidad < bienes_de_consumo.stock_minimo", bien_de_consumo_id, area_id)
    else
      @items_stock = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo")
      puts "TODOS!!!!"
    end

    @generador = GeneradorDeImpresionItemStock.new

    @generador.generar_pdf_stock_faltante(@items_stock)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )
  end

  def traer_items_stock_minimo_superado_por_bien_y_area
    bien_de_consumo_id = params[:bien_de_consumo_id]
    area_id = params[:area_id]

    @items_stock = ItemStock.joins(:bien_de_consumo, :deposito).where("cantidad < bienes_de_consumo.stock_minimo AND bien_de_consumo_id = ? AND depositos.area_id = ?", bien_de_consumo_id, area_id).paginate(:page => params[:page], :per_page => 30)
    @items_stock[0].area_id_impresion = area_id;
    @items_stock[0].bien_id_impresion = bien_de_consumo_id;

    @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(@items_stock), :precision => 3)

    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js {}
    end
  end

  def traer_cantidad_en_stock_en_suministro
    bien_id = params[:bien_id]
    deposito_id = 1 #>>>>>>>>>>>>>>>>> DEPOSITO SUMINISTRO -1 >>>>>>>>>>>>>>>>>
    @cantidad_en_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bien_id, deposito_id)
    if !@cantidad_en_stock.nil?
      @cantidad_en_stock = @cantidad_en_stock.pluck(:cantidad)
    else
      @cantidad_en_stock = nil
    end
    respond_to do | format |
          format.json { render :json => @cantidad_en_stock }
    end
  end

  def traer_datos_de_clase_y_bien
    bien_id = params[:bien_id]
    @bien_de_consumo = BienDeConsumo.find(bien_id)
    @bienes = @bien_de_consumo.clase.bienes_de_consumo
    if @bienes.nil?
      @bienes = nil
    end
    respond_to do | format |
          format.json { render :json => @bienes }
    end
  end

  private

  def guardar_costos(bdcdr)
    costo = CostoDeBienDeConsumo.new
    costoArray = CostoDeBienDeConsumo.where(bien_de_consumo_id: bdcdr.bien_de_consumo.id)
    # if costoArray && costoArray.count > 0
    #   # if bdcdr.costo > costoArray[0].costo
    #     costoArray[0].update(costo: bdcdr.costo)
    #     costo =costoArray[0]
    #   # end
    # else
      costo = CostoDeBienDeConsumo.create!(bien_de_consumo: bdcdr.bien_de_consumo,
                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: current_user.name, origen: '2')
      raise ActiveRecord::Rollback unless costo.save
    # end
    @costo_historico = CostoDeBienDeConsumoHistorico.create!(bien_de_consumo: bdcdr.bien_de_consumo,
                                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: current_user.name, origen: '2')
    raise ActiveRecord::Rollback unless @costo_historico.save

    return costo
  end

  def guardar_costo_manualmente(bien_de_consumo_id, costo)
    nuevo_costo = CostoDeBienDeConsumo.new
    nuevo_costo = CostoDeBienDeConsumo.create(bien_de_consumo_id: bien_de_consumo_id, fecha: DateTime.now, costo: costo, usuario: current_user.name, origen: '2')
    return nuevo_costo
  end

  def guardar_costo_historico(bien_de_consumo_id, costo)
    costo_historico = CostoDeBienDeConsumoHistorico.create(bien_de_consumo_id: bien_de_consumo_id, fecha: DateTime.now, costo:  costo, usuario: current_user.name, origen: '2')
    costo_historico.save
    return costo_historico
  end

  def generar_impresion

  end

  def item_stock_params
    #params.require(:item_stock).permit(:cantidad, :costo, :bien_de_consumo_id)
    params.require(:item_stock).permit!
  end
end
