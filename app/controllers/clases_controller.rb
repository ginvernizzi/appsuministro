class ClasesController < ApplicationController
  before_action :set_clase, only: [:show, :edit, :update, :destroy]  
  before_action :set_back_page, only: [:show, :new, :traer_vista_dar_de_baja_y_reemplazar] 

  autocomplete :clase, :nombre , :full => true 

  # GET /clases
  # GET /clases.json
  def index
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").paginate(:page => params[:page], :per_page => 30)
  end     


  def autocomplete_clase_nombre_traer_todas_las_clases 
    #clase_id = params[:clase_id]
    respond_to do |format|
      #if clase_id != "" 
        @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL AND clases.nombre ILIKE ?", "%#{params[:term]}%").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").paginate(:page => params[:page], :per_page => 30)
        render :json => @clases.map { |clase| {:id => clase.id, :label => clase.nombre, :value => clase.nombre} }
      #end        
      format.js { }     
    end        
  end  

  def ver_clases_dadas_de_baja
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NOT NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").paginate(:page => params[:page], :per_page => 30)
  end

  # GET /clases/1
  # GET /clases/1.json
  def show
  end

  # GET /clases/new
  def new
    @clase = Clase.new
    @partidas_parciales = PartidaParcial.includes(:partida_principal).order("partidas_principales.codigo").order("partidas_parciales.codigo")
  end

  # GET /clases/1/edit
  def edit
    @partidas_parciales = PartidaParcial.all
  end

  # POST /clases
  # POST /clases.json
  def create
    @clase = Clase.new(clase_params)

    respond_to do |format|
      if @clase.save
        format.html { redirect_to @clase, notice: 'La Clase fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @clase }
      else
        @partidas_parciales = PartidaParcial.all
        format.html { render :new }
        format.json { render json: @clase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clases/1
  # PATCH/PUT /clases/1.json
  def update
    respond_to do |format|
      if @clase.update(clase_params)
        format.html { redirect_to @clase, notice: 'La Clase fue modificada exitosamente.' }
        format.json { render :show, status: :ok, location: @clase }
      else
        @partidas_parciales = PartidaParcial.all
        format.html { render :edit }
        format.json { render json: @clase.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy    
    respond_to do |format|
      if @clase.update(fecha_de_baja: DateTime.now)     
        if @clase.tiene_items_asociados          
            @clase.bienes_de_consumo.each do |bien|
               bien.update(fecha_de_baja: DateTime.now) 
            end            
        end
        flash[:notice] = 'La clase fue dada de baja exitosamente.'  
      else    
         flash[:notice] = 'La clase no pudo ser dada de baja.'      
      end  
      format.html { redirect_to clases_path }            
      format.json { head :no_content }  
    end 
  end
      
  def traer_partidas_parciales_con_codigo_de_clase_existente
    codigo = params[:codigo]        
    @partidas_parciales = PartidaParcial.joins(:clases).where("clases.fecha_de_baja IS NULL AND clases.codigo = ?", codigo)      
          
    respond_to do |format|   
      format.js { }
    end 
  end

  
  def traer_partidas_parciales_con_nombre_de_clase_similar
    nombre = params[:nombre]        
    @partidas_parciales = PartidaParcial.joins(:clases).where("clases.fecha_de_baja IS NULL AND clases.nombre ILIKE ?", "%#{nombre}%")      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js { }
    end 
  end

def traer_vista_dar_de_baja_y_reemplazar   
    @partidas_parciales = PartidaParcial.all
    @clase = Clase.new
  end

  def dar_de_baja_y_reemplazar      
    @clase_erronea = Clase.find(params[:clase_id])        
    @clase = Clase.new(clase_params) 
    @clase.bienes_de_consumo = @clase_erronea.bienes_de_consumo
    
    respond_to do |format|            
      if @clase_erronea.update(fecha_de_baja: DateTime.now) && @clase.save              
        @reemplazo_clase = ReemplazoClase.new(clase_vieja_id:@clase_erronea.id, clase_nueva_id:@clase.id).save        
        format.html { redirect_to clases_path, notice: 'Se ha reemplazado la clase exitosamente.' }
      else            
        @partidas_parciales = PartidaParcial.all                                
        format.html { render :traer_vista_dar_de_baja_y_reemplazar }        
        format.json { render json: @clase.errors, status: :unprocessable_entity }      
      end      
    end
  end

  def traer_clase_por_id
    clase_id = params[:clase_id]    

    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL AND clases.id = ?", clase_id).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").paginate(:page => params[:page], :per_page => 30)
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js {}
    end 
  end

  def traer_todas_las_clases
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").paginate(:page => params[:page], :per_page => 30)
    respond_to do |format|   
      format.js {}
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clase
      @clase = Clase.find(params[:id])
    end

  def set_back_page
    session[:return_to] ||= request.referer
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clase_params
      params.require(:clase).permit(:codigo, :nombre, :partida_parcial_id)
    end

end
