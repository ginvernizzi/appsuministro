class BienesDeConsumoDeRecepcionController < ApplicationController
before_action :set_bien_de_consumo_de_recepcion, only: [:edit, :destroy]
before_action :setear_fijos_arbol, only: [:new]

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
      redirect_to new_recepcion_de_bien_de_consumo_bien_de_consumo_de_recepcion_path(@recepcion_de_bien_de_consumo)      
    else
      setear_fijos_arbol
      respond_to do |format|                
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
      
      respond_to do | format |                                  
          format.json { render :json => @array_bien_de_consumo }        
      end
  end

  def obtener_codigo_de_bien_de_consumo              
      @array_bien_de_consumo = BienDeConsumo.where(nombre: params[:nombre])

      codigo_completo_de_bien = obtener_codigo_completo_bien_de_consumo(params[:nombre])
      
      @array_bien_de_consumo[0].detalle_adicional = codigo_completo_de_bien
      
      respond_to do | format |                                  
          format.json { render :json => @array_bien_de_consumo }        
      end
  end

  # def obtener_codigo_completo_bien_de_consumo(nombre_de_bien_de_consumo)
  #   @array_bien_de_consumo = BienDeConsumo.where(nombre: nombre_de_bien_de_consumo)    

  #   bien = @array_bien_de_consumo[0]
  #   cod_bien = bien.codigo

  #   clase = bien.clase 
  #   cod_clase  = clase.codigo

  #   partida_parcial = clase.partida_parcial
  #   cod_partida_parcial = partida_parcial.codigo
    
  #   partida_principal = partida_parcial.partida_principal
  #   cod_partida_principal = partida_principal.codigo      

  #   inciso = partida_principal.inciso
  #   cod_inciso = inciso.codigo    

  #   codigo_completo = "#{cod_inciso}" + "." + "#{cod_partida_principal}" + "." + "#{cod_partida_parcial}" + "." + "#{cod_clase}" + "." + "#{cod_bien}"      

  #   return codigo_completo
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def setear_fijos_arbol
        # @incisos = Inciso.all
        # @partidas_principales = PartidaPrincipal.all
        # @partidas_parciales = PartidaParcial.all
        @clases = Clase.all
        @bienes_de_consumo = BienDeConsumo.all
    end

    def set_bien_de_consumo_de_recepcion      
      @bien_de_consumo_de_recepcion = BienDeConsumoDeRecepcion.find(params[:id])
    end

    def bien_de_consumo_de_recepcion_params
      params.require(:bien_de_consumo_de_recepcion).permit(:cantidad, :costo, :bien_de_consumo_id, :recepcion_de_bien_de_consumo_id)            
    end
end
