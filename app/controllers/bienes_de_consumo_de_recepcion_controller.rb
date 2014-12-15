class BienesDeConsumoDeRecepcionController < ApplicationController
before_action :set_bien_de_consumo_de_recepcion, only: [:edit, :destroy]

  def new
  	@recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])
    @bien_de_consumo_de_recepcion  = BienDeConsumoDeRecepcion.new(recepcion_de_bien_de_consumo_id: @recepcion_de_bien_de_consumo.id)    
  end

  def edit
  end

  def create
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])

	@bien_de_consumo_de_recepcion = BienDeConsumoDeRecepcion.new(bien_de_consumo_de_recepcion_params)

    if @bien_de_consumo_de_recepcion.save      
      flash[:notice] = 'El Bien de consumo fue agregado exitosamente.'
      #redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path @recepcion_de_bien_de_consumo
      redirect_to new_recepcion_de_bien_de_consumo_bien_de_consumo_de_recepcion_path(@recepcion_de_bien_de_consumo)      
    else
      respond_to do |format|        
        #flash[:error] = 'Ha ocurrido un error.'
        format.html { render :new }
        format.json { render json: @bien_de_consumo_de_recepcion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy                           
  	@recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])                                                                       
    @bien_de_consumo_de_recepcion.destroy

    respond_to do |format|  
      flash[:notice] = 'El bien de consumo fue eliminado exitosamente.'        
      format.html { redirect_to new_recepcion_de_bien_de_consumo_bien_de_consumo_de_recepcion_path(@recepcion_de_bien_de_consumo) }
      format.json { head :no_content }
    end
  end

  def obtener_nombre_de_bien_de_consumo              
      @array_bien_de_consumo = BienDeConsumo.where(codigo: params[:codigo])
      @id_de_bien = @array_bien_de_consumo[0].id    
      
      respond_to do | format |                                  
          format.json { render :json => @array_bien_de_consumo }        
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bien_de_consumo_de_recepcion      
      @bien_de_consumo_de_recepcion = BienDeConsumoDeRecepcion.find(params[:id])
    end

    def bien_de_consumo_de_recepcion_params
      params.require(:bien_de_consumo_de_recepcion).permit(:cantidad, :costo, :bien_de_consumo_id, :recepcion_de_bien_de_consumo_id)            
    end
end
