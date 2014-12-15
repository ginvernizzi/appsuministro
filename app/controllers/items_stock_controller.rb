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
    
    respond_to do |format|    
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

          @recepcion.update(estado: "6")
          flash[:notice] = 'Los bienes fueron agregados a stock exitosamente.'                                     
      else           
          flash[:notice] = 'No hay area de suministro cargada, o deposito en la misma. No se podra agergar a stock'                   
      end 
      format.html { redirect_to recepciones_de_bien_de_consumo_a_evaluar_index_path }    
    end
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
                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: 'ana', origen: '2')       
      @costo.save                  
    end                                         
    @costo_historico = CostoDeBienDeConsumoHistorico.create!(bien_de_consumo: bdcdr.bien_de_consumo, 
                                                            fecha: DateTime.now, costo: bdcdr.costo, usuario: 'ana', origen: '2') 
    @costo_historico.save

    return @costo        
  end

  def consumo_directo_params
    params.require(:item_stock).permit(:cantidad, :costo)
  end
end
