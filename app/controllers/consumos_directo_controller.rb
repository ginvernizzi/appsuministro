class ConsumosDirectoController < ApplicationController
  before_action :set_consumo_directo, only: [:show, :edit, :update, :destroy]

  
  autocomplete :obra_proyecto, :descripcion , :full => true

  # def autocomplete_obra_proyecto_descripcion
  #   @obras = ObraProyecto.where("descripcion ILIKE ?", "%#{params[:term]}%")
  #   respond_to do |format|      
  #     format.json { render json: @obras.map{ |x| x.descripcion } }
  #   end    
  # end

  # GET /consumos_directo
  # GET /consumos_directo.json
  def index
    @consumos_directo = ConsumoDirecto.all
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
            #@consumo_directo.estado = 1   
                
            recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.each do |bien| 
               @consumo_directo.bienes_de_consumo_para_consumir.build(cantidad: bien.cantidad, costo: bien.costo, 
                                                                     bien_de_consumo: bien.bien_de_consumo, deposito:deposito)


              costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,        
                                                    usuario: current_user.name, origen: "2" )
              raise ActiveRecord::Rollback unless costo_de_bien.save
              costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,
                                                    usuario: current_user.name, origen: "2" )      
              raise ActiveRecord::Rollback unless costo_de_bien_historico.save
            end 

            respond_to do |format|
              if  @consumo_directo.save
                raise ActiveRecord::Rollback unless recepcion_de_bien_de_consumo.update(estado: "5") 
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
                recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
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
            @consumo_directo = ConsumoDirecto.new(fecha: @consumo_data["fecha"], area_id: @consumo_data["area_id"] ,obra_proyecto_id: @consumo_data["obra_proyecto_id"])                

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
    #Falta
    #volver a stock la cantidad correspondiente a 
    respond_to do |format|
        if @consumo_directo.update(estado: 2)
            format.html { redirect_to consumos_directo_url, notice: 'El consumo fué dado de baja' }
            format.json { head :no_content }
        else
            format.html { redirect_to consumos_directo_url, notice: 'El consumo no pudo ser dado de baja' }
            format.json { head :no_content }
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

    puts "HOLAAA"
    puts "area_id blanco? #{area_id.blank?} #{area_id}" 
    puts "bien_id blanco? #{bien_id.blank?} #{bien_id}"
   
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
      @bien_de_consumo_para_consumir[0].fecha_inicio = params[:fecha_inicio];
      @bien_de_consumo_para_consumir[0].fecha_fin = params[:fecha_fin];
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
       @bien_de_consumo_para_consumir[0].fecha_inicio = params[:fecha_inicio];
       @bien_de_consumo_para_consumir[0].fecha_fin = params[:fecha_fin];
    end    
     
    respond_to do |format|   
      format.js {}
    end 
  end

  def imprimir_formulario_consumos_por_codigo_destino_y_fecha    
    area_id = params[:area_id]
    bien_id = params[:bien_id]

    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 
    @bienes_de_consumo_para_consumir = BienDeConsumoParaConsumir.new

    if !area_id.nil? && !bien_id.nil? && !fecha_inicio.nil? && !fecha_fin.nil?
      @bienes_de_consumo_para_consumir = BienDeConsumoParaConsumir.joins(:deposito, :consumo_directo).where("bien_de_consumo_id = ? AND consumos_directo.area_id = ? AND consumos_directo.fecha >= ? AND consumos_directo.fecha <= ?", bien_id, area_id, fecha_inicio, fecha_fin)
    end

    @generador = GeneradorDeImpresion.new
    @generador.generar_pdf_items_consumo_directo(@bienes_de_consumo_para_consumir)
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
           @bien_de_consumo_para_consumir[0].fecha_inicio = params[:fecha_inicio];
           @bien_de_consumo_para_consumir[0].fecha_fin = params[:fecha_fin];
        end
    end
          
    respond_to do |format|   
      format.js {}
    end 
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
end
