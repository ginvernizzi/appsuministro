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

  def index
    @items_stock = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)     
    @costo_total_general = number_to_currency(obtener_total_general_de_items_stock(ItemStock.all), :precision => 3)
  end

  def new
    @item_stock = ItemStock.new
    @costo = CostoDeBienDeConsumo.new
  end

  def traer_todos_los_items_stock
    respond_to do |format|   
      @items_stock = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)  
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
    bien_de_consumo_id = params[:bien_de_consumo_id]   
    date_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    date_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day()  

    @items_stock = ItemStock.where("bien_de_consumo_id = ?", -1) 

    @items_stock = ItemStock.joins(:deposito).where("bien_de_consumo_id = ? AND depositos.area_id = ? AND items_stock.created_at BETWEEN ? AND ?", bien_de_consumo_id, area_id, date_inicio, date_fin).paginate(:page => params[:page], :per_page => 30)      
    if !@items_stock.blank? && @items_stock.count > 0
      @items_stock[0].fecha_inicio_impresion = date_inicio;
      @items_stock[0].fecha_fin_impresion = date_fin;
      @items_stock[0].area_id_impresion = area_id;
      @items_stock[0].bien_id_impresion = bien_de_consumo_id;
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
    deposito_id = 1 #>>>>>>>>>>>>>>>>> DEPOSITO SUMINISTRO -1 >>>>>>>>>>>>>>>>>
    @deposito = Deposito.find(deposito_id)
    #@bien_de_consumo = BienDeConsumo.find(item_stock_params[:bien_de_consumo_id]) 
    @item_stock = ItemStock.new

    @costo = guardar_costo_manualmente(item_stock_params[:bien_de_consumo_id], params[:costo])
    @costo_historico =  guardar_costo_historico(item_stock_params[:bien_de_consumo_id], params[:costo])

    @item_stock_array = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", item_stock_params[:bien_de_consumo_id], @deposito.id)

    respond_to do |format|       
        @costo.save
        @costo_historico.save
        if @item_stock_array.count == 0  #si no hay STOCK
            @item_stock = ItemStock.new(bien_de_consumo_id: item_stock_params[:bien_de_consumo_id], cantidad: item_stock_params[:cantidad], costo_de_bien_de_consumo: @costo, deposito: @deposito)   
            if @item_stock.save 
                @costo_historico.save
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
            # else
            #    puts "***06******"
            #    format.html { render :new }
            #    format.json  { render :json => {:costo => @costo, :item_stock => @item_stock, status: :unprocessable_entity }}
            # end
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


  def imprimir_formulario_stock_total_por_bien_y_area    
    bien_de_consumo_id = params[:bien_id]
    area_id = params[:area_id] 
    fecha_fin = params[:fecha_fin] 
    fecha_inicio = params[:fecha_inicio]     

    if !bien_de_consumo_id.nil? && !area_id.nil?
      @items = ItemStock.joins(:deposito).where("bien_de_consumo_id = ? AND depositos.area_id = ? AND items_stock.created_at BETWEEN ? AND ?", bien_de_consumo_id, area_id, fecha_inicio, fecha_fin)
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
    @items = ItemStock.joins(:bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal]]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")  
    @generador.generar_pdf(@items)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_pdf)
    send_file ( file )    
  end


  def traer_items_stock_minimo_superado
    @items_stock = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo").paginate(:page => params[:page], :per_page => 30)
                   
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
    if costoArray && costoArray.count > 0
      if bdcdr.costo > costoArray[0].costo                   
        costoArray[0].update(costo: bdcdr.costo)        
        costo =costoArray[0]
      end
    else
      costo = CostoDeBienDeConsumo.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: current_user.name, origen: '2')       
      raise ActiveRecord::Rollback unless costo.save                  
    end                                         
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
