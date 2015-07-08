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

        puts ">>>>>>>>>>>>>> #{params[:codigo].to_s}"
        ############
        @cod_inciso = params[:codigo].to_s.split('.')[0]                   
        puts ">>>>>>>>>>>>>> #{@cod_inciso}"
        @cod_p_principal = params[:codigo].to_s.split('.')[1]       
        puts ">>>>>>>>>>>>>> #{@cod_p_principal}"
        @cod_p_parcial = params[:codigo].to_s.split('.')[2] 
        puts ">>>>>>>>>>>>>> #{@cod_p_parcial}"      
        @cod_clase = params[:codigo].to_s.split('.')[3]   
        puts ">>>>>>>>>>>>>> #{@cod_clase}"
        @cod_bien_de_consumo = params[:codigo].to_s.split('.')[4]     
        puts ">>>>>>>>>>>>>> #{@cod_bien_de_consumo}"

        begin          
          @inciso = Inciso.where(codigo: @cod_inciso)                                          
          puts ">>>>>>>>>>>>>> #{@inciso[0].codigo}"
                            
          @p_principal = @inciso[0].partidas_principales.where(codigo: @cod_p_principal)                  
          puts ">>>>>>>>>>>>>> #{@p_principal[0].codigo}"

          @p_parcial = @p_principal[0].partidas_parciales.where(codigo: @cod_p_parcial)        
          puts ">>>>>>>>>>>>>> #{@p_parcial[0].codigo}"

          @clase = @p_parcial[0].clases.where('clases.fecha_de_baja IS NULL AND codigo = ?', @cod_clase)        
          puts ">>>>>>>>>>>>>> #{@clase[0].codigo}"

          @array_bien_de_consumo = @clase[0].bienes_de_consumo.where(codigo: @cod_bien_de_consumo)

        rescue Exception
          @array_bien_de_consumo = BienDeConsumo.new
        end

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def setear_fijos_arbol
        # @incisos = Inciso.all
        # @partidas_principales = PartidaPrincipal.all
        # @partidas_parciales = PartidaParcial.all       
        @clases = Clase.where("fecha_de_baja IS NULL")
        @bienes_de_consumo = BienDeConsumo.where("fecha_de_baja IS NULL")
    end

    def set_bien_de_consumo_de_recepcion      
      @bien_de_consumo_de_recepcion = BienDeConsumoDeRecepcion.find(params[:id])
    end

    def bien_de_consumo_de_recepcion_params
      params.require(:bien_de_consumo_de_recepcion).permit(:cantidad, :costo, :bien_de_consumo_id, :recepcion_de_bien_de_consumo_id)            
    end
end
