class RecepcionesDeBienDeConsumoAEvaluarController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo_a_evaluar, only: [:show, :ver_rechazar, :consumo_directo]

  def index
    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where(estado: 3).order(:id)
  end

  def show
  end

  # def consumo_directo    
  #   @consumo = Consumo.new 
  # end

  def ver_rechazar
    respond_to do |format|
      format.html { render :rechazar }       
      format.json { render :rechazar }
    end
  end

  def rechazar
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])   
    respond_to do |format|                                                                                       
      if @recepcion_de_bien_de_consumo.estado == 3                
          if @recepcion_de_bien_de_consumo.update(recepcion_de_bien_de_consumo_params)
            flash[:notice] = 'La Recepcion fue rechazada exitosamente.'             
          else     
            flash[:notice] = 'Error. La Recepcion no pudo ser rechazada.'            
          end
      else
        flash[:notice] = 'La Recepcion no esta para ser evaluar.'      
      end
        format.html { redirect_to recepciones_de_bien_de_consumo_a_evaluar_index_path }          
        format.json { head :no_content }            
    end 
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recepcion_de_bien_de_consumo_a_evaluar
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])
  end

  def recepcion_de_bien_de_consumo_params
      params.require(:recepcion_de_bien_de_consumo).permit(:estado, :descripcion_rechazo)       
  end
end
