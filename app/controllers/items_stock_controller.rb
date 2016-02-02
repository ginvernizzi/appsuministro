class ItemsStockController < ApplicationController  

  autocomplete :bien_de_consumo, :nombre , :full => true, :extra_data => [:codigo]
  autocomplete :area, :nombre , :full => true

  def index
    #@items_stock = ItemStock.order(:bien_de_consumo_id)    
    @bienes_de_consumo = BienDeConsumo.all     
  end

  def traer_todos_los_items_stock
    @items_stock = ItemStock.all           
         
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js {}
    end 
  end

  def traer_items_stock_por_bien_y_area
    bien_de_consumo_id = params[:bien_de_consumo_id]    
    area_id = params[:area_id] 

    @items_stock = ItemStock.joins(:deposito).where("bien_de_consumo_id = ? AND depositos.area_id = ?", bien_de_consumo_id, area_id)      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js {}
    end 
  end

  def new
  	@item_stock = ItemStock.new
    
  end

  def ver_ingresar_a_stock
	  @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_id])	
	  @areas = Area.all
	  @depositos = Deposito.all
	  @item_stock = ItemStock.new   
  end
  
  def create    
    @recepcion = RecepcionDeBienDeConsumo.find(params[:recepciones_de_bien_de_consumo_a_evaluar_id])
    areaArray = Area.where(id: 1)
    
    
    respond_to do |format|    
      if areaArray.count > 0 && areaArray[0].depositos.count > 0
        
          @deposito = areaArray[0].depositos.first       

          @recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|

            costo_de_bien = guardar_costos(bdcdr)

            #@item_stock = ItemStock.where(:bien_de_consumo_id => bdcdr.bien_de_consumo.id && :deposito_id => @deposito.id)
            @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr.bien_de_consumo.id, @deposito.id)
            #puts "#{ areaArray[0].depositos[1].id } Y #{ @deposito.id } }"
            if @item_stock[0]              
              suma = @item_stock[0].cantidad + bdcdr.cantidad              
              @item_stock[0].update(cantidad: suma)              
            else             
              @item_stock = ItemStock.new(bien_de_consumo: bdcdr.bien_de_consumo, cantidad: bdcdr.cantidad, costo_de_bien_de_consumo: costo_de_bien, deposito: @deposito)                                
              @item_stock.save                              
              
            end                        
          end                                    

          @recepcion.update(estado: "6")
          flash[:notice] = 'Los bienes fueron agregados a stock exitosamente.'                                     
      else           
          flash[:notice] = 'No hay area de suministro cargada, o deposito en la misma. No se podra agergar a stock'                   
      end 

      format.html { redirect_to recepciones_de_bien_de_consumo_a_evaluar_index_path }    
    end
  end

  def imprimir_formulario
    @recepcion = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])      
    @generador = GeneradorDeImpresion.new
    @generador.generar_pdf(@recepcion)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )    
  end


  def imprimir_formulario_stock_total_por_bien_y_area    
    bien_de_consumo_id = params[:bien_de_consumo_id]
    area_id = params[:area_id]      

    if !bien_de_consumo_id.nil? && !area_id.nil?
      @items = ItemStock.joins(:deposito).where("bien_de_consumo_id = ? AND depositos.area_id = ?", bien_de_consumo_id, area_id)  
    else
      @items = ItemStock.all
    end
    
    @generador = GeneradorDeImpresionItemStock.new

    @generador.generar_pdf(@items)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )    
  end

      
  def imprimir_formulario_stock_total_todos_los_bienes
    @generador = GeneradorDeImpresionItemStock.new
    @items = ItemStock.all
    @generador.generar_pdf(@items)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )    
  end

  ########### stock a fecha #############
  def guardar_stock_a_fecha    
    @items_stock_a_fecha = Array.new
    deposito = Deposito.find(1) #deposito suministro "piso -1" 
    @items_stock = ItemStock.where("deposito_id = ?", deposito.id)
    
    @items_stock.each do |item_stock|
      item_stock_a_fecha = ItemStockAFecha.new(
        bien_de_consumo_id: item_stock.bien_de_consumo.id, 
        costo: item_stock.costo_de_bien_de_consumo.costo, 
        cantidad: item_stock.cantidad, 
        deposito_id: item_stock.deposito.id
      )
      item_stock_a_fecha.save
      @items_stock_a_fecha << item_stock_a_fecha
    end

    @reporte_a_fecha = ReporteAFecha.new(
      fecha: DateTime.now,
      stock_diario: @items_stock_a_fecha.to_json
    )
    
    respond_to do |format|    
      if @reporte_a_fecha.save
        flash[:notice] = 'el reporte se guardo ok'        
      else  
        #loguear error en disco, o en algun lado
        flash[:notice] = 'el reporte fallo' 
      end
      format.html { redirect_to   reportes_a_fecha_path }  
    end
  end

  def traer_items_stock_minimo_superado
    @items_stock = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo")
                   
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js {}
    end 
  end

  def traer_items_stock_minimo_superado_por_bien_y_area
    bien_de_consumo_id = params[:bien_de_consumo_id]    
    area_id = params[:area_id] 

    @items_stock = ItemStock.joins(:bien_de_consumo, :deposito).where("cantidad < bienes_de_consumo.stock_minimo AND bien_de_consumo_id = ? AND depositos.area_id = ?", bien_de_consumo_id, area_id)      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js {}
    end 
  end

  private 

  def guardar_costos(bdcdr)
    costo = CostoDeBienDeConsumo.new
    costoArray = CostoDeBienDeConsumo.where(bien_de_consumo_id: bdcdr.bien_de_consumo.id)
    if costoArray && costoArray.count > 0
      if bdcdr.costo > costoArray[0].costo                   
        costoArray[0].update(costo: bdcdr.costo)        
        costo =costoArray[0]
      end
    else
      costo = CostoDeBienDeConsumo.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: current_user.name, origen: '2')       
      costo.save                  
    end                                         
    @costo_historico = CostoDeBienDeConsumoHistorico.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: current_user.name, origen: '2') 
    @costo_historico.save

    return costo        
  end

  def generar_impresion
          
  end

  def consumo_directo_params
    params.require(:item_stock).permit(:cantidad, :costo)
  end
end
