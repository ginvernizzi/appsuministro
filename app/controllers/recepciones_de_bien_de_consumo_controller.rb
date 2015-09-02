class RecepcionesDeBienDeConsumoController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo, only: [:show, :edit, :update, :destroy]

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

  # GET /recepciones_de_bien_de_consumo/1
  # GET /recepciones_de_bien_de_consumo/1.json
  def show
  end

  # GET /recepciones_de_bien_de_consumo/new
  def new
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new
    @tipos_de_documento = TipoDeDocumento.all
    
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
if
         @recepcion_de_bien_de_consumo.save                
          flash[:notice] = 'La recepcion fue creada exitosamente.'              
          #redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path(@recepcion_de_bien_de_consumo)  
          redirect_to new_recepcion_de_bien_de_consumo_bien_de_consumo_de_recepcion_path(@recepcion_de_bien_de_consumo)                      
        else                          
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
     respond_to do |format|                                 
       @tipos_de_documento = TipoDeDocumento.all
       format.html { render :edit }
       format.json { render json: @recepcion_de_bien_de_consumo.errors, status: :unprocessable_entity }
     end
    end
  end

  #  /recepciones_de_bien_de_consumo/1
  # DELETE /recepciones_de_bien_de_consumo/1.json
  def destroy
    @recepcion_de_bien_de_consumo.destroy
    respond_to do |format|
      format.html { redirect_to recepciones_de_bien_de_consumo_url, notice: 'La Recepcion de bien de consumo eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

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
    @documentos = DocumentosDeRecepcion.joins(:tipos_de_documento).where("numero_de_documento = ?", numero)      
          
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
end
