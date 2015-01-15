class ItemsStockController < ApplicationController  
  def index
    @items_stock = ItemStock.all    
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
    @areaArray = Area.where(nombre: "Suministro")
    @items = []
    
    respond_to do |format|    
      if @areaArray.count > 0 && @areaArray[0].depositos.count > 0
        
          @deposito = @areaArray[0].depositos.first       

          @recepcion.bienes_de_consumo_de_recepcion.each do |bdcdr|

            @costo = guardar_costos(bdcdr)

            @item_stock = ItemStock.where(:bien_de_consumo_id => bdcdr.bien_de_consumo.id)
            if @item_stock[0]              
              suma = @item_stock[0].cantidad + bdcdr.cantidad              
              @item_stock[0].update(cantidad: suma)
              @items << @item_stock[0]
            else             
              @item_stock = ItemStock.new(bien_de_consumo: bdcdr.bien_de_consumo, cantidad: bdcdr.cantidad, costo_de_bien_de_consumo: @costo, deposito: @deposito)                                
              @item_stock.save                              

              @items << @item_stock
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

  private 

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
                                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: 'ana', origen: '2') 
    @costo_historico.save

    return @costo        
  end

  def generar_impresion
          
  end

  def consumo_directo_params
    params.require(:item_stock).permit(:cantidad, :costo)
  end
end
