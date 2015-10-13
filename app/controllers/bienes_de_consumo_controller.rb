class BienesDeConsumoController < ApplicationController
  before_action :set_bien_de_consumo, only: [:show, :destroy, :edit]

  def index
    #@bienes_de_consumo = BienDeConsumo.includes(:clase).where("bienes_de_consumo.fecha_de_baja IS NULL").order("clases.nombre")      

    #@bienes_de_consumo = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
    @bienes_de_consumo = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)
  end

  def new
  	@bien_de_consumo = BienDeConsumo.new
  	@incisos = Inciso.all
	  @partidas_principales = PartidaPrincipal.all
  	@partidas_parciales = PartidaParcial.all  	
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
  	@bienes_de_consumo = BienDeConsumo.all
  end

  def edit
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
  end

  def show
  end

  def ver_items_dados_de_baja
    @bienes_de_consumo = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NOT NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)    
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
    		@clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
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
    @clases = Clase.joins(:bienes_de_consumo).where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.codigo = ?", codigo)      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js { }
    end 
  end

  
  def traer_clases_con_nombre_de_bien_de_consumo_similar
    nombre = params[:nombre]        
    @clases = Clase.joins(:bienes_de_consumo).where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.nombre ILIKE ?", "%#{nombre}%")      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js { }
    end 
  end

  def destroy    
    respond_to do |format|
      if @bien_de_consumo.update(fecha_de_baja: DateTime.now)       
        flash[:notice] = 'El Bien de consumo fue dado de baja exitosamente.'
      else      
        flash[:notice] = 'Ha ocurrido un error. El Bien de consumo no pudo ser dado de baja'     
      end  

      format.html { redirect_to bienes_de_consumo_path }
      format.json { head :no_content }
    end 
  end

  def traer_vista_dar_de_baja_y_reemplazar   
    @clases = Clase.where("clases.fecha_de_baja IS NULL")
    @bien_de_consumo = BienDeConsumo.new
  end

  def dar_de_baja_y_reemplazar_bienes_de_consumo      
    @bien_de_consumo_erroneo = BienDeConsumo.find(params[:bien_de_consumo_id])        
    @bien_de_consumo = BienDeConsumo.new(bien_de_consumo_params)           
    
    respond_to do |format|      
        if @bien_de_consumo_erroneo.update(fecha_de_baja: DateTime.now) && @bien_de_consumo.save
           @reemplazo_bdc = ReemplazoBdc.new(bdc_viejo_id:@bien_de_consumo_erroneo.id, bdc_nuevo_id:@bien_de_consumo.id)
           @reemplazo_bdc.save                                              
           format.html { redirect_to bienes_de_consumo_path, notice: 'Se ha reemplazado el Bien de consumo exitosamente.' }                    
        else            
          @clases = Clase.where("clases.fecha_de_baja IS NULL")
          @bienes_de_consumo = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NULL")
                        
          format.html { render :traer_vista_dar_de_baja_y_reemplazar }        
          format.json { render json: @bien_de_consumo.errors, status: :unprocessable_entity }      
        end      
    end
  end

  def existen_stocks_minimos_superados
    resp = false

    @items = @items = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo")

    respond_to do |format|
    if @items.count > 0
      resp = true   
    end

    format.json { 
      render json: {:data => resp}
    } 
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bien_de_consumo
  	@bien_de_consumo = BienDeConsumo.find(params[:id])
  end

  def bien_de_consumo_params
	params.require(:bien_de_consumo).permit(:nombre, :codigo, :detalle_adicional, :unidad_de_medida, :clase_id, :fecha, :stock_minimo)
  end
end
