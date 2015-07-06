class ReemplazoBdcController < ApplicationController  

  def autocomplete_bien_de_consumo_dado_de_baja_nombre_by_clase 
    clase_id = params[:clase_id]
    respond_to do |format|
      if clase_id != "" 
        @bienes = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NOT NULL AND nombre ILIKE ? AND clase_id = ?", "%#{params[:term]}%", clase_id) 
        #format.json { render json: @bienes.map{ |x| x.nombre  } }
        format.json { render json: @bienes.map{ |c| {:nombre => c.nombre, :codigo => c.codigo }  } }
        #{|c| {:name => c.full_name, :id => c.id } }

        # result = @bienes do |t|
        #   { value: t.nombre,  }
        # end

        #format.json { render :json => @bienes.to_json }
        #format.json { render json: @bienes.map(&:nombre) }         
      #else
 
      end        
      format.html     
    end        
  end

  def autocomplete_bien_de_consumo_dado_de_alta_nombre_by_clase 
    clase_id = params[:clase_id]
    respond_to do |format|
      if clase_id != "" 
        @bienes = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NULL AND nombre ILIKE ? AND clase_id = ?", "%#{params[:term]}%", clase_id)         
        format.json { render json: @bienes.map{ |c| {:nombre => c.nombre, :codigo => c.codigo }  } }
      end        
      format.html     
    end        
  end

  def index
    @reemplazos_bdc = ReemplazoBdc.all
  end

  def new
  	@reemplazo_bdc = ReemplazoBdc.new
  	@bien_de_consumo_viejo = BienDeConsumo.new
  	@clases = Clase.where("fecha_de_baja IS NULL")
  end  

  def asociar_item_dado_de_baja

  end

  def traer_bien_dado_de_baja_por_clase
    codigo = params[:codigo]        
    clase_id = params[:clase_id]    
    query = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NOT NULL AND bienes_de_consumo.clase_id = ? AND bienes_de_consumo.codigo = ?", clase_id, codigo)      
    
    traer_bien_por_codigo(query);
  end

    def traer_bien_dado_de_alta_por_clase
    codigo = params[:codigo]        
    clase_id = params[:clase_id]    
    query = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.clase_id = ? AND bienes_de_consumo.codigo = ?", clase_id, codigo)      

    traer_bien_por_codigo(query);
  end

  def traer_bien_por_codigo(query)

    @resp_json = Hash.new
    @bien_de_consumo = query
    if !@bien_de_consumo.blank?
      @resp_json["bien_de_consumo_id"] = @bien_de_consumo[0].id  
      @resp_json["nombre"] = @bien_de_consumo[0].nombre
    else
      @resp_json = nil
    end 
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'    
    respond_to do | format |                                  
        format.json { render :json => @resp_json }        
    end
  end

  def traer_item_dado_de_baja_por_nombre
    nombre = params[:nombre_de_item]        
    codigo = params[:codigo_de_item]
    clase_id = params[:clase_id]    
    
    @bien_de_consumo = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NOT NULL AND bienes_de_consumo.clase_id = ? AND bienes_de_consumo.nombre = ? AND bienes_de_consumo.codigo = ?", clase_id, nombre, codigo)      
    if @bien_de_consumo.nil?
      @resp_json = nil
    end  
    
    respond_to do | format |                                  
        format.json { render :json => @bien_de_consumo.to_json }        
    end
  end

  def traer_item_dado_de_alta_por_nombre
    nombre = params[:nombre_de_item]        
    codigo = params[:codigo_de_item]
    clase_id = params[:clase_id]    
    
    @bien_de_consumo = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.clase_id = ? AND bienes_de_consumo.nombre = ? AND bienes_de_consumo.codigo = ?", clase_id, nombre, codigo)      
    if @bien_de_consumo.nil?
      @resp_json = nil
    end  
    
    respond_to do | format |                                  
        format.json { render :json => @bien_de_consumo.to_json }        
    end
  end

  
  def crear_reemplazo_de_bien_manual
    puts "HOLAAAAAAAAAAAAAAAAAAA"
    bien_viejo_id = params[:bien_de_consumo_viejo_id]        
    bien_nuevo_id = params[:bien_de_consumo_nuevo_id]            

    clase_vieja_id = params[:clase_vieja_id]   
    clase_nueva_id = params[:clase_nueva_id]     

    respond_to do |format|      
      #if clase_vieja_id == clase_vieja_id
        @reemplazo_bdc = ReemplazoBdc.new(bdc_viejo_id:bien_viejo_id, bdc_nuevo_id:bien_nuevo_id)
        if @reemplazo_bdc.save                                                      
          format.html { redirect_to reemplazo_bdc_index_path, notice: 'Se han asociado los items exitosamente.' }                    
        else
          #flash[:notice] = 'Ha ocurrido un error. No se pudo realizar la asociacion.'
          #@reemplazo_bdc.errors << "Ha ocurrido un error. No se pudo realizar la asociacion."
          #@reemplazo_bdc.errors.add(:base, "Ha ocurrido un error. No se pudo realizar la asociacion.")
        end
      #else        
        #flash[:notice] = 'Los items seleccionados deben pertenecer a la misma clase.'
        #@reemplazo_bdc.errors << 'Los items seleccionados deben pertenecer a la misma Clase.'
        #@reemplazo_bdc.errors.add(:base, "Los items seleccionados deben pertenecer a la misma Clase.")
        #@reemplazo_bdc.errors.add(:base, "Ha ocurrido un error. No se pudo realizar la asociacion.")
      #end                
      #format.html { render :nueva_asociacion_item_dado_de_baja }         
      format.html { render :_form_reemplazo_bdc }
      #format.json { render json: @reemplazo_bdc.errors, status: :unprocessable_entity }             
      #format.json { render json: @reemplazo_bdc.errors.to_json, status: :unprocessable_entity }
    end    
  end
end

