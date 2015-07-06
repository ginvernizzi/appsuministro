class ReemplazoClaseController < ApplicationController
  def autocomplete_clase_dada_de_baja_nombre_por_partida_parcial
    partida_parcial_id = params[:partida_parcial_id]
    respond_to do |format|
      if partida_parcial_id != "" 
        @clases = Clase.where("clases.fecha_de_baja IS NOT NULL AND nombre ILIKE ? AND partida_parcial_id = ?", "%#{params[:term]}%", partida_parcial_id) 
        #format.json { render json: @clases.map{ |x| x.nombre  } }
        format.json { render json: @clases.map{ |c| {:nombre => c.nombre, :codigo => c.codigo }  } }
        #{|c| {:name => c.full_name, :id => c.id } }

        # result = @clases do |t|
        #   { value: t.nombre,  }
        # end

        #format.json { render :json => @clases.to_json }
        #format.json { render json: @clases.map(&:nombre) }         
      #else
 
      end        
      format.html     
    end        
  end

  def autocomplete_clase_dada_de_alta_nombre_por_partida_parcial 
    partida_parcial_id = params[:partida_parcial_id]
    respond_to do |format|
      if partida_parcial_id != "" 
        @clases = Clase.where("clases.fecha_de_baja IS NULL AND nombre ILIKE ? AND partida_parcial_id = ?", "%#{params[:term]}%", partida_parcial_id)         
        format.json { render json: @clases.map{ |c| {:nombre => c.nombre, :codigo => c.codigo }  } }
      end        
      format.html     
    end        
  end

  def index
    @reemplazos_clase = ReemplazoClase.all
  end

  def new
  	@reemplazo_clase = ReemplazoClase.new
  	@clase_vieja = Clase.new
  	@clases = Clase.where("fecha_de_baja IS NULL")
  end  

  def asociar_clase_dada_de_baja
  end

  def traer_clase_dado_de_baja_por_partida_parcial
    codigo = params[:codigo]        
    partida_parcial_id = params[:partida_parcial_id]    
    query = Clase.where("clases.fecha_de_baja IS NOT NULL AND clases.partida_parcial_id = ? AND clases.codigo = ?", partida_parcial_id, codigo)      
    
    traer_bien_por_codigo(query);
  end

    def traer_clase_dada_de_alta_por_partida_parcial
    codigo = params[:codigo]        
    partida_parcial_id = params[:partida_parcial_id]    
    query = Clase.where("clases.fecha_de_baja IS NULL AND clases.partida_parcial_id = ? AND clases.codigo = ?", partida_parcial_id, codigo)      

    traer_clase_por_codigo(query);
  end

  def traer_clase_por_codigo(query)

    @resp_json = Hash.new
    @clase = query
    if !@clase.blank?
      @resp_json["clase_id"] = @clase[0].id  
      @resp_json["nombre"] = @clase[0].nombre
    else
      @resp_json = nil
    end 
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'    
    respond_to do | format |                                  
        format.json { render :json => @resp_json }        
    end
  end

  def traer_clase_dada_de_baja_por_nombre
    nombre = params[:nombre_de_clase]        
    codigo = params[:codigo_de_clase]
    partida_parcial_id = params[:partida_parcial_id]    
    
    @clase = Clase.where("clases.fecha_de_baja IS NOT NULL AND clases.partida_parcial_id = ? AND clases.nombre = ? AND clases.codigo = ?", partida_parcial_id, nombre, codigo)      
    if @clase.nil?
      @resp_json = nil
    end  
    
    respond_to do | format |                                  
        format.json { render :json => @clase.to_json }        
    end
  end

  def traer_clase_dada_de_alta_por_nombre
    nombre = params[:nombre_de_clase]        
    codigo = params[:codigo_de_clase]
    partida_parcial_id = params[:partida_parcial_id]    
    
    @clase = Clase.where("clases.fecha_de_baja IS NULL AND clases.partida_parcial_id = ? AND clases.nombre = ? AND clases.codigo = ?", partida_parcial_id, nombre, codigo)      
    if @clase.nil?
      @resp_json = nil
    end  
    
    respond_to do | format |                                  
        format.json { render :json => @clase.to_json }        
    end
  end

  
  def crear_reemplazo_de_clase_manual
    clase_vieja_id = params[:clase_vieja_id]        
    clase_nueva_id = params[:clase_nueva_id]            

    clase_vieja_id = params[:clase_vieja_id]   
    clase_nueva_id = params[:clase_nueva_id]     

    respond_to do |format|      
      if clase_vieja_id == clase_vieja_id
        @reemplazo_clase = ReemplazoClase.new(clase_vieja_id:clase_vieja_id, clase_nueva_id:clase_nueva_id)
        if @reemplazo_clase.save                                                      
          format.html { redirect_to reemplazo_clase_index_path, notice: 'Se han asociado las clases exitosamente.' }                    
        else
          #flash[:notice] = 'Ha ocurrido un error. No se pudo realizar la asociacion.'
          #@reemplazo_clase.errors << "Ha ocurrido un error. No se pudo realizar la asociacion."
          #@reemplazo_clase.errors.add(:base, "Ha ocurrido un error. No se pudo realizar la asociacion.")
        end        
      else
        #flash[:notice] = 'Los items seleccionados deben pertenecer a la misma clase.'
        #@reemplazo_clase.errors << 'Los items seleccionados deben pertenecer a la misma Clase.'
        @reemplazo_clase.errors.add(:base, "Ha ocurrido un error. No se pudo realizar la asociacion.")
      end                
      #format.html { render :nueva_asociacion_item_dado_de_baja }   
      format.html { render :_form_reemplazo_clase }   
          
      #format.json { render json: @reemplazo_clase.errors.to_json, status: :unprocessable_entity }
    end    
  end
end
