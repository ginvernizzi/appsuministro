class TransferenciasController < ApplicationController
  before_action :set_transferencia, only: [:show, :edit, :update, :destroy]

  # GET /transferencias
  # GET /transferencias.json
  def index
    @transferencia = Transferencia.all
  end

  # GET /transferencias/1
  # GET /transferencias/1.json
  def show
  end

  # GET /transferencias/new
  def new
    @transferencia = Transferencia.new    
    @areas = Area.all
  end

  def nueva_transferencia_desde_recepcion
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_id])
    @transferencia = Transferencia.new       

    @areas = Area.all
    #area_suministro_id = 1 #Area = 1 ==> Patrimonio y Suministro
    #@areas = Area.where.not(id: area_suministro_id)
    cargar_datos_controles_transferencias
  end

  # GET /transferencias/1/edit
  def edit
  end

  # POST /transferencias
  # POST /transferencias.json
  def create
    Transferencia.transaction do      

      #ingresar bienes a stock de suministro, y luego quitarlos.
      recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
      @deposito_origen = Deposito.find(1) #Deposito "-1" de "Patrimonio y suministro"      
      @deposito_destino = Deposito.find(transferencia_params[:deposito_id])      
      
      if (ingresar_bienes_a_stock(recepcion_de_bien_de_consumo, @deposito_origen))
          quitar_bienes_de_stock(recepcion_de_bien_de_consumo, @deposito_origen)
          ingresar_bienes_a_stock(recepcion_de_bien_de_consumo, @deposito_destino)       
      
        @transferencia = Transferencia.new(transferencia_params)
            
        recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.each do |bien| 
          @transferencia.bienes_de_consumo_para_transferir.build(cantidad: bien.cantidad, costo: bien.costo, 
                                                                 bien_de_consumo_id: bien.bien_de_consumo_id, deposito: @deposito_destino)


          costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo: bien.bien_de_consumo, costo: bien.costo,        
                                                usuario: current_user.name, origen: "2" )
          costo_de_bien.save

          costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo: bien.bien_de_consumo, costo: bien.costo,
                                                usuario: current_user.name, origen: "2" )      
          costo_de_bien_historico.save
        end    

        respond_to do |format|
          if @transferencia.save && recepcion_de_bien_de_consumo.update(estado: "5")
            format.html { redirect_to @transferencia, notice: 'La Transferencia fue realizada exitosamente' }
            #format.json { render :show, status: :created, location: @transferencia }
          else
            recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
            cargar_datos_controles_consumo_directo
            format.html { render :nuevo_consumo_directo_desde_recepcion }
            format.json { render json: @transferencia.errors, status: :unprocessable_entity }
          end
        end
      else

      end
    end
  end

  def nueva_transferencia
    @transferencia = Transferencia.new      
    cargar_datos_controles_transferencias
  end

  def crear_transferencia               
    @transferencia_data = ActiveSupport::JSON.decode(params[:transferencia])   
    bienes_tabla = @transferencia_data["bienes_tabla"]      
    deposito_destino = Deposito.find(@transferencia_data["deposito_id"])     

    Transferencia.transaction do          
      #ingresar bienes a stock de suministro, y luego quitarlos.      
      if (quitar_bienes_de_stock_transferencia_manual(bienes_tabla))
        ingresar_bienes_a_stock_transferencia_manual(deposito_destino, bienes_tabla)
      
        @transferencia = Transferencia.new(fecha: @transferencia_data["fecha"], area_id: @transferencia_data["area_id"] ,deposito_id: @transferencia_data["deposito_id"])                

        @transferencia_data["bienes_tabla"].each do |bien|           
          
          @bien_de_consumo = BienDeConsumo.find(bien["Id"]) 
          deposito = Deposito.find(bien["DepoId"]) 

          @transferencia.bienes_de_consumo_para_transferir.build(cantidad:bien["Cantidad a transferir"], costo: CostoDeBienDeConsumo.where(bien_de_consumo_id: @bien_de_consumo.id)[0].costo, 
                                                                 bien_de_consumo_id: @bien_de_consumo.id, deposito: deposito)


          costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo_id: @bien_de_consumo.id, costo: CostoDeBienDeConsumo.where(bien_de_consumo_id: @bien_de_consumo.id)[0].costo,        
                                             usuario: current_user.name, origen: "2" )
          costo_de_bien.save

          @costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo_id:  @bien_de_consumo.id, costo: CostoDeBienDeConsumo.where(bien_de_consumo_id: @bien_de_consumo.id)[0].costo,
                                                usuario: current_user.name, origen: "2" )      
          @costo_de_bien_historico.save
        end    

        respond_to do |format|
          if @transferencia.save                                                              
            format.json { render json: @transferencia }
          else              
            cargar_datos_controles_transferencias
            format.html { render :nueva_transferencia }            
            #format.json { render json:  @transferencia.errors, status: :unprocessable_entity }
          end
        end
      else

      end 
    end #transaction
  end #def

  # PATCH/PUT /transferencias/1
  # PATCH/PUT /transferencias/1.json
  def update
    respond_to do |format|
      if @transferencia.update(transferencia_params)
        format.html { redirect_to @transferencia, notice: 'Transferencia was successfully updated.' }
        format.json { render :show, status: :ok, location: @transferencia }
      else
        format.html { render :edit }
        format.json { render json: @transferencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transferencias/1
  # DELETE /transferencias/1.json
  def destroy
    @transferencia.destroy
    respond_to do |format|
      format.html { redirect_to transferencias_url, notice: 'Transferencia was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def imprimir_formulario()
    @transferencia = Transferencia.find(params[:transferencia_id])      
    @generador = GeneradorDeImpresionTransferencia.new
    @generador.generar_pdf_transferencia(@transferencia)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_transferencia_pdf)
    send_file ( file )         
  end

  #igual que la funcion que usa consumo_controller
  def ingresar_bienes_a_stock(recepcion, deposito)    
    recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|        
      @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr.bien_de_consumo.id, deposito.id)      
      if @item_stock[0]                      
        puts "existe Bien y deposito"
        suma = @item_stock[0].cantidad + bdcdr.cantidad              
        @item_stock[0].update(cantidad: suma)              
      else             
        costo_nuevo = guardar_costos(bdcdr)  
        puts "NO existe Bien y deposito"
        @item_stock = ItemStock.create!(bien_de_consumo: bdcdr.bien_de_consumo, cantidad: bdcdr.cantidad, costo_de_bien_de_consumo:costo_nuevo, deposito: deposito)                                
        @item_stock.save                                          
      end                        
    end                                    
    return true                                           
  end

  def ingresar_bienes_a_stock_transferencia_manual(deposito, bienes)    
    bienes.each do |bdcdr|  
      @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr["Id"], deposito.id)      
      if @item_stock[0]                              
        suma = @item_stock[0].cantidad + bdcdr["Cantidad a transferir"].to_i  
        puts "**********SUMA************** #{@item_stock[0].cantidad} + #{bdcdr["Cantidad a transferir"].to_i}"           
        @item_stock[0].update(cantidad: suma)              
      else             
        bien_de_consumo = BienDeConsumoDeRecepcion.where(bien_de_consumo: bdcdr["Id"]) 
        costo_nuevo = guardar_costos(bien_de_consumo)          
        @item_stock = ItemStock.create!(bien_de_consumo: bien_de_consumo[0].bien_de_consumo, cantidad: bdcdr["Cantidad a transferir"].to_i, costo_de_bien_de_consumo:costo_nuevo, deposito: deposito)                                
        @item_stock.save                                          
      end                        
    end                                    
    return true                                           
  end
 
  private
  #Por ahora descuenta de suministro, pero hay que pasar el deposito origen, y el destino
  def quitar_bienes_de_stock(recepcion, deposito)
      recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|            
        @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr.bien_de_consumo.id, deposito.id)
        if @item_stock[0]
          resta = @item_stock[0].cantidad - bdcdr.cantidad              
          @item_stock[0].update(cantidad: resta)    
          puts "Existe Bien y deposito"          
        else             
          #Es imposible que no exista, ya que fue creado en el metodo del controller al ingresar stock              
          puts "NO existe Bien y deposito o hay un error en la base"
          return false    
        end                        
      end                                    
      return true      
    end

    def quitar_bienes_de_stock_transferencia_manual(bienes)                
      bienes.each do |bdcdr|                                           
          @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bdcdr["Id"], bdcdr["DepoId"])           
          if @item_stock[0]
            puts "**********QUITA************** #{@item_stock[0].cantidad} - #{bdcdr["Cantidad a transferir"].to_i}" 
            resta = @item_stock[0].cantidad - bdcdr["Cantidad a transferir"].to_i              
            @item_stock[0].update(cantidad: resta)              
          else             
            #Es imposible que no exista, ya que fue creado en el metodo del controller al ingresar stock              
            #o puede pasar de que se lo hayan consumido o transferido un instante antes.
            return false            
          end               
        #end
      end 
      return true      
    end

    def guardar_costos(bdcdr)
      costo = CostoDeBienDeConsumo.new
      costoArray = CostoDeBienDeConsumo.where(bien_de_consumo_id: bdcdr[0].bien_de_consumo.id)
      if costoArray && costoArray.count > 0
        if bdcdr[0].costo > costoArray[0].costo                   
          costoArray[0].update(costo: bdcdr[0].costo)                
        end
        costo = costoArray[0]
      else      
        costo = CostoDeBienDeConsumo.create!(bien_de_consumo: bdcdr[0].bien_de_consumo, 
                                              fecha: DateTime.now, costo: bdcdr[0].costo, usuario: current_user.name, origen: '2')       
        costo.save                 
      end                                         
      @costo_historico = CostoDeBienDeConsumoHistorico.create!(bien_de_consumo: bdcdr[0].bien_de_consumo, 
                                                              fecha: DateTime.now, costo: bdcdr[0].costo, usuario: current_user.name, origen: '2') 
      @costo_historico.save

      return costo        
    end    

    ###############################

    # Use callbacks to share common setup or constraints between actions.
    def set_transferencia
      @transferencia = Transferencia.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transferencia_params      
      #params.require(:transferencia).permit(:fecha, :area_id, :deposito_id)
      params.require(:transferencia).permit! 
    end

    def cargar_datos_controles_transferencias                
      @depositos = Array.new()
      @areas = Area.all
    end
end
