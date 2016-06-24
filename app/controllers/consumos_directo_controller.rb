class ConsumosDirectoController < ApplicationController
  before_action :set_consumo_directo, only: [:show, :edit, :update, :destroy]
  before_action :set_back_page, only: [:show] 

  autocomplete :obra_proyecto, :descripcion , :full => true

  # GET /consumos_directo
  # GET /consumos_directo.json
  def index
    estado_activo = 1 #estado activo
    @consumos_directo = ConsumoDirecto.where("estado = ?", estado_activo).includes(:area, :obra_proyecto, :recepciones_de_bien_de_consumo).order(:id => "desc").paginate(:page => params[:page], :per_page => 30)
    #@bienes_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("consumos_directo.estado = ?", estado_activo)  
  end

  def ver_dados_de_baja
    estado = 2 #estado activo
    @consumos_directo = ConsumoDirecto.where("estado = ?", 2).order(:id => "desc")
  end

  # GET /consumos_directo/1
  # GET /consumos_directo/1.json
  def show
  end

  # GET /consumos_directo/new
  def new
    @consumo_directo = ConsumoDirecto.new    
  end
    
  def nuevo_consumo_directo_desde_recepcion
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_id])
    @consumo_directo = ConsumoDirecto.new   
    cargar_datos_controles_consumo_directo
  end
 
  # GET /consumos_directo/1/edit
  def edit    
    @areas = Area.all.order(:nombre)
    @obras_proyecto = ObraProyecto.all.order(:descripcion)
  end

  # POST /consumos_directo
  # POST /consumos_directo.json
  def create
    ActiveRecord::Base.transaction do      
      begin 
        #ingresar bienes a stock de suministro, y luego quitarlos.
        recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
        deposito = Deposito.find(1) #deposito 1 = deposito de patrimonio y suministro
        
          if (ingresar_bienes_a_stock(recepcion_de_bien_de_consumo))
            quitar_bienes_de_stock(recepcion_de_bien_de_consumo)
          
            @consumo_directo = ConsumoDirecto.new(consumo_directo_params)
            @consumo_directo.estado = 1   
                
            recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.each do |bien| 
              @consumo_directo.bienes_de_consumo_para_consumir.build(cantidad: bien.cantidad, costo: bien.costo, 
                                                                     bien_de_consumo: bien.bien_de_consumo, deposito:deposito)


              costo = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,        
                                                    usuario: current_user.name, origen: "2" )
              raise ActiveRecord::Rollback unless costo.save
              costo_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,
                                                    usuario: current_user.name, origen: "2" )      
              raise ActiveRecord::Rollback unless costo_historico.save
            end 

            respond_to do |format|
              if  @consumo_directo.save
                #Cambio estado recepcion a finalizada por consumo inmediato
                raise ActiveRecord::Rollback unless recepcion_de_bien_de_consumo.update(estado: "8") 
                #raise ActiveRecord::Rollback unless RecepcionParaConsumoDirecto.create(recepcion_de_bien_de_consumo: recepcion_de_bien_de_consumo, consumo_directo:@consumo_directo) 
                raise ActiveRecord::Rollback unless recepcion_de_bien_de_consumo.consumos_directo << @consumo_directo
                flash[:notice] = 'Consumo creado exitosamente'
                if existen_stocks_minimos_superados
                  flash[:error] = 'Hay items con stock minimo superado. Revise la lista de stocks faltante'       
                end
                format.html { redirect_to  @consumo_directo }
                #format.json { render :show, status: :created, location: consumo_directo }
              else
                raise ActiveRecord::Rollback
              end
            end
          end #if ingresos a stock
        rescue ActiveRecord::Rollback
          respond_to do |format|
                @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
                cargar_datos_controles_consumo_directo
                format.html { render :nuevo_consumo_directo_desde_recepcion }
                format.json { render json:  @consumo_directo.errors, status: :unprocessable_entity }
          end
        end #begin    
      end #transaction
  end #def

  def nuevo_consumo
    @consumo_directo = ConsumoDirecto.new      
    cargar_datos_controles_consumo_directo
  end

  def crear_consumo          
      @consumo_data = ActiveSupport::JSON.decode(params[:consumo_directo])    
      ActiveRecord::Base.transaction do      
        begin               
            @consumo_directo = ConsumoDirecto.new(fecha: @consumo_data["fecha"], area_id: @consumo_data["area_id"] ,obra_proyecto_id: @consumo_data["obra_proyecto_id"], estado: 1)                

            @consumo_data["bienes_tabla"].each do |bien|           
              
              @bien_de_consumo = BienDeConsumo.find(bien["Id"]) 
              deposito = Deposito.find(bien["DepoId"]) 

               @consumo_directo.bienes_de_consumo_para_consumir.build(cantidad:bien["Cantidad a consumir"], costo: CostoDeBienDeConsumo.where(bien_de_consumo_id: @bien_de_consumo.id)[0].costo , 
                                                                     bien_de_consumo_id: @bien_de_consumo.id, deposito: deposito)
              costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo_id: @bien_de_consumo.id, costo: CostoDeBienDeConsumo.where(bien_de_consumo_id: @bien_de_consumo.id)[0].costo,        
                                                 usuario: current_user.name, origen: "2" )
             
              raise ActiveRecord::Rollback unless costo_de_bien.save

              @costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo_id:  @bien_de_consumo.id, costo: CostoDeBienDeConsumo.where(bien_de_consumo_id: @bien_de_consumo.id)[0].costo,
                                                    usuario: current_user.name, origen: "2" )      
              raise ActiveRecord::Rollback unless @costo_de_bien_historico.save
            end    

            respond_to do |format|
              if @consumo_directo.save
                quitar_bienes_de_stock_consumo_manual(@consumo_data["bienes_tabla"])
                flash[:notice] = 'Consumo directo creado exitosamente'
                if existen_stocks_minimos_superados
                  flash[:error] = 'Hay items con stock minimo superado. Revise la lista de stocks'       
                end                
                format.json { render json: @consumo_directo }
              else
                raise ActiveRecord::Rollback
              end
            end
        rescue ActiveRecord::Rollback
            respond_to do |format|
                cargar_datos_controles_consumo_directo
                #ormat.html { render :nuevo_consumo }                        
                format.html { render action: 'nuevo_consumo' }
            end
        end #begin
      end #transaction
  end #def

  # PATCH/PUT /consumos_directo/1
  # PATCH/PUT /consumos_directo/1.json
  def update
    respond_to do |format|
      if @consumo_directo.update(consumo_directo_params)
        format.html { redirect_to @consumo_directo, notice: 'Consumo directo was successfully updated.' }
        format.json { render :show, status: :ok, location: @consumo_directo }
      else
        format.html { render :edit }
        format.json { render json: @consumo_directo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumos_directo/1
  # DELETE /consumos_directo/1.json
  def destroy
    ActiveRecord::Base.transaction do      
      begin              
        @consumo_directo.recepciones_de_bien_de_consumo[0] ? @recepcion = @consumo_directo.recepciones_de_bien_de_consumo[0] : @recepcion = nil

        @consumo_directo.bienes_de_consumo_para_consumir.each do |bien|
          @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bien.bien_de_consumo.id, bien.deposito_id)
          if !@item_stock.first.nil?              
            suma = @item_stock.first.cantidad + bien.cantidad              
            raise ActiveRecord::Rollback unless @item_stock.first.update(cantidad: suma)              
          else                        
            raise ActiveRecord::Rollback                                      
          end  
          volver_costo_de_bien_al_anterior(bien) unless @recepcion.nil?
        end 
      
        respond_to do |format|
          if @consumo_directo.update(estado: 2) 
            if !@recepcion.nil?
              raise ActiveRecord::Rollback unless @recepcion.update(estado: 7) 
            end
            format.html { redirect_to consumos_directo_url, notice: 'El consumo fué dado de baja exitosamante' }
            format.json { head :no_content }
          else
            raise ActiveRecord::Rollback  
          end
        end
      rescue ActiveRecord::Rollback
        respond_to do |format|
          format.html { redirect_to consumos_directo_url, notice: 'El consumo no pudo ser dado de baja. Consulte con el administrador del sistema' }
          format.json { head :no_content }
        end
      end #begin
    end #transaction
  end #def

  def volver_costo_de_bien_al_anterior(bien_de_consumo_a_consumir)
    ActiveRecord::Base.transaction do      
      begin              
        #Volver al ultimo costo ##### Si el costo del bien en la recepcion es igual al ultimo costo del item, voler y traer el costo inmediato anterior
        costo_actual = CostoDeBienDeConsumo.where("bien_de_consumo_id = ?", bien_de_consumo_a_consumir.bien_de_consumo.id).last.costo
        if bien_de_consumo_a_consumir.costo == costo_actual
          costo_inmediato_anterior = bien_de_consumo_a_consumir.bien_de_consumo.id.last(2).first.costo
          costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo: bien_de_consumo_a_consumir.bien_de_consumo, costo: costo_inmediato_anterior,        
                                             usuario: current_user.name, origen: "2" )           
          costo_de_bien.save!
          @costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo:  bien_de_consumo_a_consumir.bien_de_consumo, costo: costo_inmediato_anterior,
                                                usuario: current_user.name, origen: "2" )      
          @costo_de_bien_historico.save!
        end
      rescue Exception => e
        puts "Se produjo el siguiente error: #{e} " 
        raise ActiveRecord::Rollback
      end
    end
end

  def ingresar_bienes_a_stock(recepcion)
    areaArray = Area.where(id: 1)    
    if areaArray.count > 0 && areaArray[0].depositos.count > 0
        deposito = areaArray[0].depositos.first       
        recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|
          costo_de_bien = guardar_costos(bdcdr)         
          @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr.bien_de_consumo.id, deposito.id)
          if @item_stock[0]              
            puts "existe el item" 
            suma = @item_stock[0].cantidad + bdcdr.cantidad              
            raise ActiveRecord::Rollback unless @item_stock[0].update(cantidad: suma)              
          else             
            puts "NO existe el item"
            @item_stock = ItemStock.new(bien_de_consumo: bdcdr.bien_de_consumo, cantidad: bdcdr.cantidad, costo_de_bien_de_consumo: costo_de_bien, deposito:deposito)                                
            raise ActiveRecord::Rollback unless @item_stock.save                                          
          end                        
        end                                    
        return true                                        
    else           
        return false
    end       
  end

  def quitar_bienes_de_stock(recepcion)
    areaArray = Area.where(id: 1)    
      if areaArray.count > 0 && areaArray[0].depositos.count > 0
          deposito = areaArray[0].depositos.first   
          recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|            
            
            @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr.bien_de_consumo.id, deposito.id)
            if @item_stock[0]
              resta = @item_stock[0].cantidad - bdcdr.cantidad              
              raise ActiveRecord::Rollback unless @item_stock[0].update(cantidad: resta)              
            else             
              #Es imposible que no exista, ya que fue creado en el metodo del controller al ingresar stock              
              return false    
            end                        
          end                                    

          return true
      else           
          return false
      end       
  end

  def quitar_bienes_de_stock_consumo_manual(bienes)
      bienes.each do |bdcdr|                                           
          @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr["Id"], bdcdr["DepoId"])           
          if @item_stock[0]
            resta = @item_stock[0].cantidad - bdcdr["Cantidad a consumir"].to_i 
            raise ActiveRecord::Rollback unless @item_stock[0].update(cantidad: resta)             
          else             
            #Es imposible que no exista, ya que fue creado en el metodo del controller al ingresar stock              
            return false            
          end               
      end                                    
      return true    
  end

  #Repetido en el controler de item_stock, ver la manera de usar el mismo metodo.
  def guardar_costos(bdcdr)
    costo = CostoDeBienDeConsumo.new
    costoArray = CostoDeBienDeConsumo.where(bien_de_consumo_id: bdcdr.bien_de_consumo.id)
    if costoArray && costoArray.count > 0
      if bdcdr.costo > costoArray[0].costo                   
        costoArray[0].update(costo:bdcdr.costo)        
      end
      costo = costoArray[0]
    else
      costo = CostoDeBienDeConsumo.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                            fecha: DateTime.now, costo:bdcdr.costo, usuario: current_user.name, origen: '2')       
      costo.save                  
    end                                         
    @costo_historico = CostoDeBienDeConsumoHistorico.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                                            fecha: DateTime.now, costo:bdcdr.costo, usuario: current_user.name, origen: '2') 
    @costo_historico.save

    return costo        
  end

  def ver_consumos_por_codigo_destino_fecha    
  end

  def traer_consumos_por_codigo_destino_y_fecha
    area_id = params[:area_id]
    bien_id = params[:bien_id]

    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
   
    @bien_de_consumo_para_consumir = nil

    if !area_id.blank? && !bien_id.blank? 
      puts "************ LOS DOS!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("bien_de_consumo_id = ? AND consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", bien_id, area_id, fecha_inicio, fecha_fin)        
    end

    if bien_id.blank? && !area_id.blank? 
      puts "************ solo el AREA!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", area_id, fecha_inicio, fecha_fin)      
    end
      
    if area_id.blank? && !bien_id.blank?
      puts "************ Solo el BIEN!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("bien_de_consumo_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", bien_id, fecha_inicio, fecha_fin)        
    end
            
    if !@bien_de_consumo_para_consumir.nil? && @bien_de_consumo_para_consumir.count > 0
      @bien_de_consumo_para_consumir[0].fecha_inicio_impresion = fecha_inicio;
      @bien_de_consumo_para_consumir[0].fecha_fin_impresion = fecha_fin;
      @bien_de_consumo_para_consumir[0].area_id_impresion = area_id;
    end    
     
    respond_to do |format|   
      format.js {}
    end 
  end  

  def ver_consumos_por_partida_parcial_destino_fecha  
  end

  def traer_consumos_por_partida_parcial_destino_y_fecha

    codigo_pp = params[:partida_parcial]
    inciso = codigo_pp[0].to_s
    ppal = codigo_pp[1].to_s 
    pparcial = codigo_pp[2].to_s

    area_id = params[:area_id]

    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
   
    @bien_de_consumo_para_consumir = nil

    if !area_id.blank? && !codigo_pp.blank? 
      puts "************ LOS DOS!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("incisos.codigo = ? AND partidas_principales.codigo = ? AND partidas_parciales.codigo = ? AND consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?",inciso, ppal, pparcial, area_id, fecha_inicio, fecha_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")        
    end

    if codigo_pp.blank? && !area_id.blank? 
      puts "************ solo el AREA!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", area_id, fecha_inicio, fecha_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")      
    end
      
    if area_id.blank? && !codigo_pp.blank?
      area_id = nil
      puts "************ Solo el BIEN!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("incisos.codigo = ? AND partidas_principales.codigo = ? AND partidas_parciales.codigo = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", inciso, ppal, pparcial, fecha_inicio, fecha_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
    end
            
    if !@bien_de_consumo_para_consumir.nil? && @bien_de_consumo_para_consumir.count > 0
      @bien_de_consumo_para_consumir[0].fecha_inicio_impresion  = fecha_inicio
      @bien_de_consumo_para_consumir[0].fecha_fin_impresion  = fecha_fin
      @bien_de_consumo_para_consumir[0].ppal_impresion  = codigo_pp
      @bien_de_consumo_para_consumir[0].area_id_impresion  = area_id
    end    
     
    respond_to do |format|   
      format.js {}
    end 
  end  

  def ver_consumos_y_transferencias_por_nombre_y_fecha 
  end

  def traer_consumos_y_transferencias_por_nombre_y_fecha
    bien_id = params[:bien_id]

    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
   
    @bien_de_consumo_para_consumir = nil

    if !bien_id.blank?      
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:bien_de_consumo, :consumo_directo).where("bienes_de_consumo.id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", bien_id, fecha_inicio, fecha_fin) | 
                                      BienDeConsumoParaTransferir.joins(:bien_de_consumo, :transferencia).where("bienes_de_consumo.id = ? AND transferencias.fecha >= ? AND transferencias.fecha <= ?", bien_id, fecha_inicio, fecha_fin) 
    # else
    #   @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:bien_de_consumo, :consumo_directo).where("consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", fecha_inicio, fecha_fin) | 
    #                                   BienDeConsumoParaTransferir.joins(:bien_de_consumo, :transferencia).where("transferencias.fecha >= ? AND transferencias.fecha <= ?", fecha_inicio, fecha_fin)                             
    end

            
    if !@bien_de_consumo_para_consumir.nil? && @bien_de_consumo_para_consumir.count > 0
       @bien_de_consumo_para_consumir[0].fecha_inicio_impresion = params[:fecha_inicio];
       @bien_de_consumo_para_consumir[0].fecha_fin_impresion = params[:fecha_fin];
    end    
     
    respond_to do |format|   
      format.js {}
    end 
  end

  ####################
  def ver_consumos_por_fecha_destino_y_clase    
  end

  def traer_consumos_por_fecha_destino_y_clase   
    area_id = params[:area_id]
    clase = params[:clase]
    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
   
    @bien_de_consumo_para_consumir = nil
    query_consumos_por_fecha_destino_y_clase(area_id, clase, fecha_inicio, fecha_fin)
            
    if !@bien_de_consumo_para_consumir.nil? && @bien_de_consumo_para_consumir.count > 0
      @bien_de_consumo_para_consumir[0].fecha_inicio_impresion = fecha_inicio;
      @bien_de_consumo_para_consumir[0].fecha_fin_impresion = fecha_fin;
      @bien_de_consumo_para_consumir[0].area_id_impresion = area_id;
      #@bien_de_consumo_para_consumir[0].clase = clase;
    end    
     
    respond_to do |format|   
      format.js {}
    end 
  end  
  ################

  def imprimir_formulario_consumos_por_fecha_destino_y_clase 
    area_id = params[:area_id]
    clase = params[:clase]
    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
   
    @bien_de_consumo_para_consumir = nil
    query_consumos_por_fecha_destino_y_clase(area_id, clase, fecha_inicio, fecha_fin)
            
    if !@bien_de_consumo_para_consumir.nil? && @bien_de_consumo_para_consumir.count > 0
      @bien_de_consumo_para_consumir[0].fecha_inicio_impresion = fecha_inicio;
      @bien_de_consumo_para_consumir[0].fecha_fin_impresion = fecha_fin;
      @bien_de_consumo_para_consumir[0].area_id_impresion = area_id;
      @bien_de_consumo_para_consumir[0].clase_impresion = clase;
    end    

    @generador = GeneradorDeImpresion.new
    @generador.items_dados_de_baja_por_area_destino_y_clase(@bien_de_consumo_para_consumir)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_consumo_items_pdf)
    send_file ( file )         
  end

  def imprimir_formulario_consumos_por_codigo_destino_y_fecha
    area_id = params[:area_id]
    bien_id = params[:bien_id]

    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day()

    if !area_id.blank? && !bien_id.blank? 
      puts "************ LOS DOS!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("bien_de_consumo_id = ? AND consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", bien_id, area_id, fecha_inicio, fecha_fin)        
    end

    if bien_id.blank? && !area_id.blank? 
      puts "************ solo el AREA!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", area_id, fecha_inicio, fecha_fin)      
    end
      
    if area_id.blank? && !bien_id.blank?
      puts "************ Solo el BIEN!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("bien_de_consumo_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", bien_id, fecha_inicio, fecha_fin)        
    end

    @bien_de_consumo_para_consumir.each do |i|
      i.consumo_directo.recepciones_de_bien_de_consumo[0] ? i.descripcion_de_recepcion = i.consumo_directo.recepciones_de_bien_de_consumo[0].bienes_de_consumo_de_recepcion.where("bien_de_consumo_id = ?", i.bien_de_consumo.id).first.descripcion : nil       
    end

    @generador = GeneradorDeImpresion.new

    @generador.generar_pdf_items_consumo_directo(@bien_de_consumo_para_consumir)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_consumo_items_pdf)
    send_file ( file )         
  end

  def imprimir_formulario_consumos_por_partida_parcial_destino_y_fecha
    
    codigo_pp = params[:codigo_partida_parcial]
    area_id = params[:area_id]

    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
   
    @bien_de_consumo_para_consumir = nil

    if !area_id.blank? && !codigo_pp.blank? 
      inciso = codigo_pp[0].to_s
      ppal = codigo_pp[1].to_s 
      pparcial = codigo_pp[2].to_s

      puts "************ LOS DOS!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("incisos.codigo = ? AND partidas_principales.codigo = ? AND partidas_parciales.codigo = ? AND consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?",inciso, ppal, pparcial, area_id, fecha_inicio, fecha_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")        
    end

    if codigo_pp.blank? && !area_id.blank? 
      puts "************ solo el AREA!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", area_id, fecha_inicio, fecha_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")      
    end
      
    if area_id.blank? && !codigo_pp.blank?
      inciso = codigo_pp[0].to_s
      ppal = codigo_pp[1].to_s 
      pparcial = codigo_pp[2].to_s
      puts "************ Solo el BIEN!"
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo, :bien_de_consumo => [:clase => [:partida_parcial => [:partida_principal => [:inciso]]]]).where("incisos.codigo = ? AND partidas_principales.codigo = ? AND partidas_parciales.codigo = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", inciso, ppal, pparcial, fecha_inicio, fecha_fin).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
    end

    @bien_de_consumo_para_consumir.each do |i|
      i.consumo_directo.recepciones_de_bien_de_consumo[0] ? i.descripcion_de_recepcion = i.consumo_directo.recepciones_de_bien_de_consumo[0].bienes_de_consumo_de_recepcion.where("bien_de_consumo_id = ?", i.bien_de_consumo.id).first.descripcion : nil       
    end
            
    @generador = GeneradorDeImpresion.new
    @generador.generar_pdf_items_consumo_directo(@bien_de_consumo_para_consumir)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_consumo_items_pdf)
    send_file ( file ) 
  end

  def imprimir_formulario_items_consumo
    @consumo = ConsumoDirecto.find(params[:consumo_directo_id])      
    @generador = GeneradorDeImpresion.new
    @generador.generar_pdf_consumo_directo(@consumo.bienes_de_consumo_para_consumir)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_consumo_items_pdf)
    send_file ( file )         
  end


  def imprimir_formulario
    @consumo = ConsumoDirecto.find(params[:consumo_directo_id])      
    @generador = GeneradorDeImpresion.new
    @generador.generar_pdf_consumo_directo(@consumo)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_consumo_pdf)
    send_file ( file )         
  end

  def imprimir_formulario_consumos_y_transferencias_por_nombre_y_fecha              
    bien_id = params[:bien_id]
    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
    #@bienes_de_consumo_para_consumir = BienDeConsumoParaConsumir.new

    if !bien_id.nil? && !fecha_inicio.nil? && !fecha_fin.nil?
      @bienes_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:bien_de_consumo, :consumo_directo).where("bienes_de_consumo.id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", bien_id, fecha_inicio, fecha_fin) | 
                                        BienDeConsumoParaTransferir.joins(:bien_de_consumo, :transferencia).where("bienes_de_consumo.id = ? AND transferencias.fecha >= ? AND transferencias.fecha <= ?", bien_id, fecha_inicio, fecha_fin) 
    end

    @generador = GeneradorDeImpresionSeguimientoSalidas.new
    @generador.generar_pdf_items_seguimiento_de_salidas(@bienes_de_consumo_para_consumir)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_seguimiento_salidas_pdf)
    send_file ( file )         
  end

  def ajax_download
    send_file params[:file]
  end

  def obtener_nombre_y_stock_de_bien_de_consumo_por_id_y_deposito
      if params[:deposito_id] == nil || params[:deposito_id] == ""
        params[:deposito_id] = ""
      end

      @array_bien_de_consumo = BienDeConsumo.where(id: params[:bien_id]) 
      @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", params[:bien_id], params[:deposito_id])      

      @resp_json = Hash.new
      @resp_json["bien_de_consumo_id"] = @array_bien_de_consumo[0].id  
      @resp_json["nombre"] = @array_bien_de_consumo[0].nombre 
      @resp_json["codigo"] = obtener_codigo_completo_bien_de_consumo(@array_bien_de_consumo[0].nombre ) 

      if(@item_stock[0])        
        @resp_json["cantidad_en_stock"] = @item_stock[0].cantidad
      else
        @resp_json["cantidad_en_stock"] = 0.0
      end

      respond_to do | format |                                  
          format.json { render :json => @resp_json }        
      end
  end

  def obtener_nombre_de_bien_de_consumo
          
      ############
      @cod_inciso = params[:codigo].to_s.split('.')[0]                   
      @cod_p_principal = params[:codigo].to_s.split('.')[1]       
      @cod_p_parcial = params[:codigo].to_s.split('.')[2]       
      @cod_clase = params[:codigo].to_s.split('.')[3]       
      @cod_bien_de_consumo = params[:codigo].to_s.split('.')[4]     

      @inciso = Inciso.where(codigo: @cod_inciso)

      @p_principal = @inciso[0].partidas_principales.where(codigo: @cod_p_principal)

      @p_parcial = @p_principal[0].partidas_parciales.where(codigo: @cod_p_parcial)

      @clase = @p_parcial[0].clases.where(codigo: @cod_clase)

      @array_bien_de_consumo = @clase[0].bienes_de_consumo.where(codigo: @cod_bien_de_consumo)

      #############

      @deposito = Deposito.where(id: params[:deposito_id])      
              
      @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", @array_bien_de_consumo[0].id, @deposito[0].id)      

      @resp_json = Hash.new
      @resp_json["bien_de_consumo_id"] = @array_bien_de_consumo[0].id  
      @resp_json["nombre"] = @array_bien_de_consumo[0].nombre 

      if(@item_stock[0])        
        @resp_json["cantidad_en_stock"] = @item_stock[0].cantidad
      else
        @resp_json["cantidad_en_stock"] = 0.0
      end

      respond_to do | format |                                  
          format.json { render :json => @resp_json }        
      end
  end

  def obtener_responsable_de_area   
    @resp_json = Hash.new
    if params[:area_id] != ""
      @area = Area.where(id: params[:area_id])        
      @resp_json["responsable"] = @area[0].responsable          
    else
      @resp_json["responsable"] = ""
    end
    respond_to do | format |                                  
        format.json { render :json => @resp_json }        
    end
  end


  def ver_consumos_directos_por_obra_proyecto_y_fecha
  end
  
  def traer_consumos_por_obra_proyecto_destino_y_fecha
    obra_proyecto_id = params[:obra_proyecto_id]    
    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 

    @bien_de_consumo_para_consumir = nil

    if !obra_proyecto_id.nil? && !obra_proyecto_id.blank? && !fecha_inicio.nil? && !fecha_fin.nil?
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:deposito, :consumo_directo).where("consumos_directo.obra_proyecto_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", obra_proyecto_id, fecha_inicio, fecha_fin)
        if @bien_de_consumo_para_consumir.count > 0
           @bien_de_consumo_para_consumir[0].fecha_inicio_impresion = fecha_inicio;
           @bien_de_consumo_para_consumir[0].fecha_fin_impresion = fecha_fin;
           @bien_de_consumo_para_consumir[0].obra_proyecto_impresion = obra_proyecto_id;           
        end
    end
          
    respond_to do |format|   
      format.js {}
    end 
  end

  def imprimir_formulario_consumos_por_obra_proyecto_y_fecha
    obra_proyecto_id = params[:obra_proyecto_id]    
    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 

    @bien_de_consumo_para_consumir = nil

    if !obra_proyecto_id.nil? && !obra_proyecto_id.blank? && !fecha_inicio.nil? && !fecha_fin.nil?
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:deposito, :consumo_directo).where("consumos_directo.obra_proyecto_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", obra_proyecto_id, fecha_inicio, fecha_fin)
        if @bien_de_consumo_para_consumir.count > 0
          @bien_de_consumo_para_consumir[0].fecha_inicio_impresion = fecha_inicio;
          @bien_de_consumo_para_consumir[0].fecha_fin_impresion = fecha_fin;
          @bien_de_consumo_para_consumir[0].obra_proyecto_impresion = obra_proyecto_id;    

          @bien_de_consumo_para_consumir.each do |i|
            i.consumo_directo.recepciones_de_bien_de_consumo[0] ? i.descripcion_de_recepcion = i.consumo_directo.recepciones_de_bien_de_consumo[0].bienes_de_consumo_de_recepcion.where("bien_de_consumo_id = ?", i.bien_de_consumo.id).first.descripcion : nil       
          end
        end
    end

    @generador = GeneradorDeImpresionItemsDeConsumo.new
    @generador.generar_pdf_items_consumo_directo(@bien_de_consumo_para_consumir)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_consumo_items_pdf)
    send_file ( file )         
  end

  def obtener_item_para_agregar_a_recepcion_by_id
      puts "************** controller aca"
      @bien_de_consumo_id = params[:bien_id]
      @deposito_id = params[:deposito_id]
      @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", @bien_de_consumo_id, @deposito_id)            
      @cantidad_a_consumir = params[:cantidad_a_consumir]  

      @bien_de_consumo = BienDeConsumo.find(@bien_de_consumo_id) 
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.new(bien_de_consumo_id: @bien_de_consumo_id, deposito_id: @deposito_id, cantidad: @cantidad_a_consumir) 
      #@bien_de_consumo_para_consumir.bien_de_consumo = @bien_de_consumo

      item_existe = params[:item_existe]
      if item_existe == "true"
        @mensaje_error = "Ya existe el bien"
      end

      @consumo_directo = ConsumoDirecto.new     
      @consumo_directo.bienes_de_consumo_para_consumir << @bien_de_consumo_para_consumir
      
      respond_to do | format |                                  
        format.js { }
      end
  end

  def query_consumos_por_fecha_destino_y_clase(area_id, clase, fecha_inicio, fecha_fin)
    if !area_id.blank? && !clase.blank?
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo, :bien_de_consumo => [:clase]).where("clases.codigo = ? AND consumos_directo.area_id = ? AND consumos_directo.fecha BETWEEN ? AND ?", clase, area_id, fecha_inicio, fecha_fin).order("consumos_directo.id")
    end

    if !area_id.blank? && clase.blank?
      @bien_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:consumo_directo).where("consumos_directo.area_id = ? AND consumos_directo.fecha BETWEEN ? AND ?", area_id, fecha_inicio, fecha_fin)        
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumo_directo
      @consumo_directo = ConsumoDirecto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consumo_directo_params
      #params.require(:consumo_directo).permit(:fecha, :area_id, :obra_proyecto_id, :bien_de_consumo_para_consumir_ids => [])      
      params.require(:consumo_directo).permit! 
    end

    def cargar_datos_controles_consumo_directo        
        @areas = Area.order(:nombre)
        @obras_proyecto = ObraProyecto.order(:descripcion)
    end

    def set_back_page
      session[:return_to] ||= request.referer
    end
end
