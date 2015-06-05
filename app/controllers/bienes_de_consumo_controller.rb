class BienesDeConsumoController < ApplicationController
  before_action :set_bien_de_consumo, only: [:show]

  def index
    @bienes_de_consumo = BienDeConsumo.includes(:clase).order("clases.nombre")      
  end

  def new
  	@bien_de_consumo = BienDeConsumo.new
  	@incisos = Inciso.all
	@partidas_principales = PartidaPrincipal.all
  	@partidas_parciales = PartidaParcial.all
  	@clases = Clase.all
  	@bienes_de_consumo = BienDeConsumo.all
  end

  def show
  end

  def traer_vista_de_categoria  	  
    categoria = params[:categoria]

    
    respond_to do |format|   
		case categoria
		when "inciso"
	  		@inciso = Inciso.new	  	 	      
	   
		when "partida_principal"
	  		@partida_principal = PartidaPrincipal.new 
		when "partida_parcial"
			@partida_parcial = PartidaParcial.new 
		when "clase"
	  		@clase = Clase.new 
		else
			@clase_id = params[:id]
	  		@bien_de_consumo = BienDeConsumo.new 
	  		format.js { render :action => 'traer_vista_de_bien_de_consumo' }
		end         	
	end 
  end

  def create
    @bien_de_consumo = BienDeConsumo.new(bien_de_consumo_params)    

    respond_to do |format|
      if @bien_de_consumo.save
        format.html { redirect_to new_bien_de_consumo_path(@area), notice: 'El Bien de consumo fue agregado exitosamente.' }   
        #format.json { render :show, status: :created, location: @bien_de_consumo }

      else        
        @incisos = Inciso.all
  		  @partidas_principales = PartidaPrincipal.all
    		@partidas_parciales = PartidaParcial.all
    		@clases = Clase.all
    		@bienes_de_consumo = BienDeConsumo.all

  		#format.html { render :new }
        # format.html { render :partial => "/bienes_de_consumo/form_bien_de_consumo" }
        #format.js { render :action => 'traer_vista_de_bien_de_consumo' }
        format.html { render :new }
        format.json { render json: @bien_de_consumo.errors, status: :unprocessable_entity }
      end
    end
  end


  def traer_clases_con_codigo_de_bien_existente
    codigo = params[:codigo]        
    @clases = Clase.joins(:bienes_de_consumo).where("bienes_de_consumo.codigo = ?", codigo)      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js { }
    end 
  end

  
  def traer_clases_con_nombre_de_bien_de_consumo_similar
    nombre = params[:nombre]        
    @clases = Clase.joins(:bienes_de_consumo).where("bienes_de_consumo.nombre ILIKE ?", "%#{nombre}%")      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js { }
    end 
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bien_de_consumo
  	@bien_de_consumo = BienDeConsumo.find(params[:id])
  end

  def bien_de_consumo_params
	params.require(:bien_de_consumo).permit(:nombre, :codigo, :detalle_adicional, :unidad_de_medida, :clase_id)
  end
end
