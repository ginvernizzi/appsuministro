class RecepcionesDeBienDeConsumoController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo, only: [:show, :edit, :update, :destroy]
  before_action :set_back_page, only: [:show] 

  # GET /recepciones_de_bien_de_consumo
  # GET /recepciones_de_bien_de_consumo.json
  def index    
    # estado 1: provisorio 
    # estado 2: definitivo
    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where("estado = 1 OR estado = 2").order(:id)
  end

  def ver_rechazadas    
    # estado 4: rechazadas
    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where("estado = 4").order(:id)
  end

  def ver_finalizadas 
    # estado 8: finalizadas
    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where("estado = 8").order(:id)
  end

  # GET /recepciones_de_bien_de_consumo/1
  # GET /recepciones_de_bien_de_consumo/1.json
  def show
  end

  # GET /recepciones_de_bien_de_consumo/new
  def new
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new
    @tipos_de_documento = TipoDeDocumento.all

    @estados = RecepcionDeBienDeConsumo::ESTADOS.first(2)
    
    #inicializa la cantidad de rows de doc secundarios a agregar la primera vez
    gon.numeroDeFila = 1    
  end

  # GET /recepciones_de_bien_de_consumo/1/edit
  def edit    
    @tipos_de_documento = TipoDeDocumento.all    
  end

  # POST /recepciones_de_bien_de_consumo
  # POST /recepciones_de_bien_de_consumo.json
  def create    
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new(fecha: params[:recepcion_de_bien_de_consumo][:fecha], 
                                                                 estado: params[:recepcion_de_bien_de_consumo][:estado], 
                                                                 descripcion_provisoria: params[:descripcion_provisoria])  
    
    @tddp = TipoDeDocumento.find_by_id(params[:tdp][:tipo_de_documento_id])    
    

    @docRecepcion_p = DocumentoDeRecepcion.new(numero_de_documento: params[:recepcion_de_bien_de_consumo][:documento_principal], tipo_de_documento: @tddp)
    

    @recepcion_de_bien_de_consumo.build_documento_principal(documento_de_recepcion:@docRecepcion_p, 
                                                            recepcion_de_bien_de_consumo: @recepcion_de_bien_de_consumo)

        
      if params[:ltds] 
          params[:ltds].each { |k, v|          
            if (k.include? "numero_doc_secundario")
              @numero_doc = v            
            else
              @tipo_de_documento_id = v                        
            end                                                                                    

            if(@numero_doc && @tipo_de_documento_id)  

              @tdds = TipoDeDocumento.find_by_id(@tipo_de_documento_id)            
              @docRecepcion_s = DocumentoDeRecepcion.new(numero_de_documento: @numero_doc, tipo_de_documento: @tdds)
              @recepcion_de_bien_de_consumo.documentos_secundario.new(documento_de_recepcion: @docRecepcion_s,
                                                                  recepcion_de_bien_de_consumo: @recepcion_de_bien_de_consumo)

              @numero_doc = nil
              @tipo_de_documento_id = nil           
            end
            }
      end
        if @recepcion_de_bien_de_consumo.save                
          flash[:notice] = 'La recepcion fue creada exitosamente.'              
          #redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path(@recepcion_de_bien_de_consumo)  
          redirect_to new_recepcion_de_bien_de_consumo_bien_de_consumo_de_recepcion_path(@recepcion_de_bien_de_consumo)                      
        else                      
            @tipos_de_documento = TipoDeDocumento.all
            @estados = RecepcionDeBienDeConsumo::ESTADOS.first(2)    
            respond_to do |format|  
              gon.numeroDeFila = 1;            
              @tipos_de_documento = TipoDeDocumento.all
              format.html { render :new }
              format.json { render json: @recepcion_de_bien_de_consumo.errors, status: :unprocessable_entity }
            end
      end
  end

  # PATCH/PUT /recepciones_de_bien_de_consumo/1
  # PATCH/PUT /recepciones_de_bien_de_consumo/1.json
  def update
    @recepcion_de_bien_de_consumo.update(estado: params[:recepcion_de_bien_de_consumo][:modificar_estado], 
                                descripcion_provisoria: params[:descripcion_provisoria])  
    
    @tddp = TipoDeDocumento.find_by_id(params[:tdp][:tipo_de_documento_id])               
    @docRecepcion_p = DocumentoPrincipal.find(params[:documento_primario_id]).documento_de_recepcion
    @docRecepcion_p.update(numero_de_documento: params[:recepcion_de_bien_de_consumo][:documento_principal], tipo_de_documento: @tddp)
                                                 
    if !params[:tds][:tipo_de_documento_secundario_id].empty? && !params[:numero_doc_secundario].empty?
      @tdds = TipoDeDocumento.find(params[:tds][:tipo_de_documento_secundario_id])        
      @docRecepcion_s = DocumentoDeRecepcion.new(numero_de_documento: params[:numero_doc_secundario], tipo_de_documento: @tdds)
      
      @recepcion_de_bien_de_consumo.documentos_secundario.new(documento_de_recepcion: @docRecepcion_s,
                                                              recepcion_de_bien_de_consumo: @recepcion_de_bien_de_consumo)                
    end
                        
    if @recepcion_de_bien_de_consumo.save!               
       flash[:notice] = 'La recepcion fue modificada exitosamente.'    
       puts "#{params[:commit]}" 
        if  params[:commit] == 'Agregar documento'
          redirect_to edit_recepcion_de_bien_de_consumo_path(@recepcion_de_bien_de_consumo)               
        else          
          redirect_to new_recepcion_de_bien_de_consumo_bien_de_consumo_de_recepcion_path(@recepcion_de_bien_de_consumo)                                    
        end
     else  
     @tipos_de_documento = TipoDeDocumento.all
      @estados = RecepcionDeBienDeConsumo::ESTADOS.first(2)            
     respond_to do |format|                                 
       format.html { render :edit }
       format.json { render json: @recepcion_de_bien_de_consumo.errors, status: :unprocessable_entity }
     end
    end
  end

  #  /recepciones_de_bien_de_consumo/1
  # DELETE /recepciones_de_bien_de_consumo/1.json
  def destroy
    ActiveRecord::Base.transaction do      
      begin   
        if  @recepcion_de_bien_de_consumo.estado == 8 #finalizado
          if !@recepcion_de_bien_de_consumo.recepcion_en_stock.nil? #asociacion en stock NO es nula? fue ingresada a stock?  
            puts "RECEPCION FINALIZADA POR INGRESO A STOCK"
            eliminar_recepcion_enviada_a_stock(@recepcion_de_bien_de_consumo)
          elsif !@recepcion_de_bien_de_consumo.consumos_directo[0].nil?   #consumo NO es nulo? = tiene asociado un consumo?
              puts "********RECEPCION FINALIZADA POR consumo********"
              eliminar_recepcion_enviada_a_consumo(@recepcion_de_bien_de_consumo)
          else 
            # No corresponde, si esta finalizada, tiene que ser por consumo o por ingreso a stock, si pasa esto es porque es una recepcion que se quiere
            #eliminar creada antes de crear este modulo.
            #puts 'No se pueden volver sus items para atras. Es una recepcion que se quiere eliminar antes de crear este modulo.' 
            raise ActiveRecord::Rollback unless @recepcion_de_bien_de_consumo.update(estado: 7) #anulada
          end
        else
            if @recepcion_de_bien_de_consumo.estado == 1 || @recepcion_de_bien_de_consumo.estado == 2
             puts "*****RECEPCION VIGENTE*******"
             @recepcion_de_bien_de_consumo.destroy  
            end 
        end 
        
        respond_to do |format|
          format.html { redirect_to :back,  notice: 'La Recepcion ha sido eliminada exitosamente.'  }
          format.json { head :no_content }
        end
      rescue ActiveRecord::Rollback
        respond_to do |format|
          format.html { redirect_to back, notice: 'Ha ocurrido un error. La Recepcion no pudo ser eliminada.' }
          format.json { head :no_content }
        end
      end #begin
    end #transaction  
  end

  #Los items consumidos vuelven a stock
  def eliminar_recepcion_enviada_a_consumo(recepcion)  
        consumo_directo_asociado = recepcion.consumos_directo[0]          
        consumo_directo_asociado.bienes_de_consumo_para_consumir.each do |bien|
          @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bien.bien_de_consumo.id, bien.deposito_id)
          if !@item_stock.first.nil?              
            suma = @item_stock.first.cantidad + bien.cantidad              
            raise ActiveRecord::Rollback unless @item_stock.first.update(cantidad: suma)              
          else                        
            raise ActiveRecord::Rollback                                      
          end  
          volver_costo_de_bien_al_anterior(bien) unless recepcion.nil?
        end 
      
        if consumo_directo_asociado.update(estado: 2) 
          if !recepcion.nil?
            raise ActiveRecord::Rollback unless recepcion.update(estado: 7) 
          end
        else
          raise ActiveRecord::Rollback  
        end
  end #def


  #Los items consumidos vuelven a stock
  def eliminar_recepcion_enviada_a_stock(recepcion)  
        deposito_id = 1 #s>>>>>>>> DEPOSITO SUMINISTRO -1 >>>>>>
        recepcion.bienes_de_consumo_de_recepcion.each do |bien|
          @item_stock = ItemStock.where("bien_de_consumo_id = ? AND deposito_id = ?", bien.bien_de_consumo.id, deposito_id)
          if !@item_stock.first.nil?              
            resta = @item_stock.first.cantidad - bien.cantidad              
            raise ActiveRecord::Rollback unless @item_stock.first.update(cantidad: resta)              
          else                        
            raise ActiveRecord::Rollback                                      
          end  
          volver_costo_de_bien_al_anterior(bien) unless recepcion.nil?
        end 
              
        if !recepcion.nil?
          raise ActiveRecord::Rollback unless recepcion.update(estado: 7) 
        end        
  end #def


  def eliminar_documento_secundario     
      @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])                 
      @documento_secundario = DocumentoSecundario.find(params[:documento_secundario_id])    
      @documento_secundario.destroy
      respond_to do |format|    
        flash[:notice] ='El documento fue eliminado exitosamente.' 
        format.html { redirect_to edit_recepcion_de_bien_de_consumo_path(@recepcion_de_bien_de_consumo) }                    
        format.json { head :no_content }
      end
  end

  def pegar_campo_descripcion_provisoria
        render(:partial => 'descripcion_provisoria')                                  
  end

  def enviar_a_evaluar
  @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])   
    respond_to do |format|                                                                                       
      if @recepcion_de_bien_de_consumo.estado == 1              
          if @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.length > 0                 
            if @recepcion_de_bien_de_consumo.update(estado: "3")                 
              flash[:notice] = 'La Recepcion fue enviada a evaluacion exitosamente.'             
            else     
              flash[:notice] = 'Error. La Recepcion no pudo ser enviada a evaluar.'            
            end
            format.html { redirect_to recepciones_de_bien_de_consumo_url }          
            format.json { head :no_content }                      
          else
            flash[:alert] = 'La Recepcion no tiene items asignados. No puede ser enviada a evaluar.'      
          end
      else
        flash[:alert] = 'La Recepcion no es definitiva. No puede ser enviada a evaluar.'      
      end
      format.html { redirect_to recepciones_de_bien_de_consumo_url }          
    end 
  end

  def traer_documentos_con_numero_existente
    numero = params[:numero]        
    @documentos = DocumentoDeRecepcion.joins(:tipo_de_documento).where("numero_de_documento = ?", numero)      
          
    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|   
      format.js { }
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recepcion_de_bien_de_consumo
      @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])          
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recepcion_de_bien_de_consumo_params
      params.require(:recepcion_de_bien_de_consumo).permit!           
    end

    def set_back_page
      session[:return_to] ||= request.referer
    end
end
