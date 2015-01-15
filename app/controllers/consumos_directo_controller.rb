class ConsumosDirectoController < ApplicationController
  before_action :set_consumo_directo, only: [:show, :edit, :update, :destroy]

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
  end

  # POST /consumos_directo
  # POST /consumos_directo.json
  def create    
    ConsumoDirecto.transaction do      

      #ingresar bienes a stock de suministro, y luego quitarlos.
      @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
      
      if (ingresar_bienes_a_stock(@recepcion_de_bien_de_consumo))
        quitar_bienes_de_stock(@recepcion_de_bien_de_consumo)
      
        @consumo_directo = ConsumoDirecto.new(consumo_directo_params)
            
        @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.each do |bien| 
          @consumo_directo.bienes_de_consumo_para_consumir.build(cantidad: bien.cantidad, costo: bien.costo, 
                                                                 bien_de_consumo_id: bien.bien_de_consumo_id)


          @costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,        
                                                usuario: current_user.name, origen: "2" )
          @costo_de_bien.save

          @costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,
                                                usuario: current_user.name, origen: "2" )      
          @costo_de_bien_historico.save
        end    

        respond_to do |format|
          if @consumo_directo.save && @recepcion_de_bien_de_consumo.update(estado: "5")
            format.html { redirect_to @consumo_directo, notice: 'Consumo directo creado exitosamente' }
            format.json { render :show, status: :created, location: @consumo_directo }
          else
            @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
            cargar_datos_controles_consumo_directo
            format.html { render :nuevo_consumo_directo_desde_recepcion }
            format.json { render json: @consumo_directo.errors, status: :unprocessable_entity }
          end
        end
      else
        
      end
    end
  end

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
    @consumo_directo.destroy
    respond_to do |format|
      format.html { redirect_to consumos_directo_url, notice: 'Consumo directo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def ingresar_bienes_a_stock(recepcion)
    @recepcion = recepcion
    @areaArray = Area.where(nombre: "Suministro")    
        
    if @areaArray.count > 0 && @areaArray[0].depositos.count > 0
        
        @deposito = @areaArray[0].depositos.first       

        @recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|

          @costo = guardar_costos(bdcdr)

          @item_stock = ItemStock.where(:bien_de_consumo_id => bdcdr.bien_de_consumo.id)
          if @item_stock[0]              
            suma = @item_stock[0].cantidad + bdcdr.cantidad              
            @item_stock[0].update(cantidad: suma)              
          else             
            @item_stock = ItemStock.new(bien_de_consumo: bdcdr.bien_de_consumo, cantidad: bdcdr.cantidad, costo_de_bien_de_consumo: @costo, deposito: @deposito)                                
            @item_stock.save                                          
          end                        
        end                                    

        return true                                        
    else           
        return false
    end       
  end

  def quitar_bienes_de_stock(recepcion)
    @recepcion = recepcion
    @areaArray = Area.where(nombre: "Suministro")
    @items = []
        
      if @areaArray.count > 0 && @areaArray[0].depositos.count > 0
        
          @deposito = @areaArray[0].depositos.first       

          @recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|            

            @item_stock = ItemStock.where(:bien_de_consumo_id => bdcdr.bien_de_consumo.id)
            if @item_stock[0]
              resta = @item_stock[0].cantidad - bdcdr.cantidad              
              @item_stock[0].update(cantidad: resta)
              @items << @item_stock[0]
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

  #Repetido en el controler de item_stock, ver la manera de usar el mismo metodo.
  def guardar_costos(bdcdr)
    @costo = CostoDeBienDeConsumo.where(bien_de_consumo_id: bdcdr.bien_de_consumo.id)
    if @costo && @costo.count > 0
      if bdcdr.costo > @costo[0].costo                   
        @costo[0].update(costo: bdcdr.costo)        
        @costo = @costo[0]
      end
    else
      @costo = CostoDeBienDeConsumo.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: current_user.name, origen: '2')       
      @costo.save                  
    end                                         
    @costo_historico = CostoDeBienDeConsumoHistorico.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: current_user.name, origen: '2') 
    @costo_historico.save

    return @costo        
  end

  def imprimir_formulario
    @consumo = ConsumoDirecto.find(params[:consumo_directo_id])      
    @generador = GeneradorDeImpresion.new
    @generador.generar_pdf_consumo_directo(@consumo)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_consumo_pdf)
    send_file ( file )    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumo_directo
      @consumo_directo = ConsumoDirecto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consumo_directo_params
      params.require(:consumo_directo).permit(:fecha, :area_id, :obra_proyecto_id)
    end

    def cargar_datos_controles_consumo_directo        
      @obras_proyecto = ObraProyecto.all      
      @areas = Area.all
    end
end
