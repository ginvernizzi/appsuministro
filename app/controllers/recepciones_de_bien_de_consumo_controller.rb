class RecepcionesDeBienDeConsumoController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo, only: [:show, :edit, :update, :destroy]

  # GET /recepciones_de_bien_de_consumo
  # GET /recepciones_de_bien_de_consumo.json
  def index    
    @estado_a_evaluar = 3 #numero de hash  perteneciente al estado de recepcion "a_evaluar"
    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where("estado != 3").order(:id)
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

  end

  # POST /recepciones_de_bien_de_consumo
  # POST /recepciones_de_bien_de_consumo.json
  def create    
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new(fecha: params[:recepcion_de_bien_de_consumo][:fecha], 
                                                                 estado: params[:recepcion_de_bien_de_consumo][:estado], 
                                                                 descripcion_provisoria: params[:recepcion_de_bien_de_consumo][:descripcion_provisoria])  
    
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
          redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path(@recepcion_de_bien_de_consumo)        
        else                          
          respond_to do |format|  
            gon.numeroDeFila = 1;            
            @tipos_de_documento = TipoDeDocumento.all
            format.html { render :new }
            format.json { render json: @recepcion_de_bien_de_consumo.errors, status: :unprocessable_entity }
        end
      end
  end

  def new_bienes
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])
    @bien_de_consumo_de_recepcion  = BienDeConsumoDeRecepcion.new
    @bien_de_consumo  = BienDeConsumo.new
  end

  def save_bienes        
    puts "Datos Bien de consumo"
    #puts params[:bien_de_consumo]
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])
    #@bdc = BienDeConsumo.where(nombre: params[:nombre]) 


    puts "Ver params"
    puts params.inspect
    puts "#####################"
    puts "Ver params 2"
    puts recepcion_de_bien_de_consumo_params[:bienes_de_consumo_de_recepcion].inspect
    

    @bien_de_consumo_de_recepcion = @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.create(
          cantidad:params[:recepcion_de_bien_de_consumo][:bien_de_consumo_de_recepcion][:cantidad], 
          costo:params[:recepcion_de_bien_de_consumo][:bien_de_consumo_de_recepcion][:costo], 
          bien_de_consumo_id: params[:recepcion_de_bien_de_consumo][:bien_de_consumo_de_recepcion][:bien_de_consumo][:id])

    #@bien_de_consumo_de_recepcion = @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.create!(recepcion_de_bien_de_consumo_params[:bien_de_consumo_de_recepcion])     
    #@bien_de_consumo_de_recepcion = @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.create!(params[:recepcion_de_bien_de_consumo][:bien_de_consumo_de_recepcion])     
    #@bien_de_consumo_de_recepcion = @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.create!(params[:recepcion_de_bien_de_consumo])     
    #@bien_de_consumo_de_recepcion = @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.build(params[:recepcion_de_bien_de_consumo])     
    #@recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.update(params[:recepcion_de_bien_de_consumo])
    #@recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.update_attributes(params[:recepcion_de_bien_de_consumo])

    #@bien_de_consumo_de_recepcion = @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.create!(recepcion_de_bien_de_consumo_params[:bienes_de_consumo_de_recepcion_attributes]['0'])    

    #recepcion_de_bien_de_consumo.update_attributes(recepcion_de_bien_de_consumo_params[:bienes_de_consumo_de_recepcion_attributes]['0'])    

    #@recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.create!(recepcion_de_bien_de_consumo_params[:bienes_de_consumo_de_recepcion_attributes])
    #@recepcion_de_bien_de_consumo.update_attributes(recepcion_de_bien_de_consumo_params)

    if @recepcion_de_bien_de_consumo.save
    #if @bien_de_consumo_de_recepcion.save
      flash[:notice] = 'El Bien de consumo fue agregado exitosamente.'
      redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path @recepcion_de_bien_de_consumo
    else
      respond_to do |format|
        @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.reload
        #flash[:error] = 'Ha ocurrido un error.'
        format.html { render :new_bienes }
        format.json { render json: @recepcion_de_bien_de_consumo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recepciones_de_bien_de_consumo/1
  # PATCH/PUT /recepciones_de_bien_de_consumo/1.json
  def update
    respond_to do |format|
      if @recepcion_de_bien_de_consumo.update(recepcion_de_bien_de_consumo_params)
        format.html { redirect_to @recepcion_de_bien_de_consumo, notice: 'La Recepcion de bien de consumo fue actulizada exitosamente.' }
        format.json { render :show, status: :ok, location: @recepcion_de_bien_de_consumo }
      else
        format.html { render :edit }
        format.json { render json: @recepcion_de_bien_de_consumo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recepciones_de_bien_de_consumo/1
  # DELETE /recepciones_de_bien_de_consumo/1.json
  def destroy
    @recepcion_de_bien_de_consumo.destroy
    respond_to do |format|
      format.html { redirect_to recepciones_de_bien_de_consumo_url, notice: 'La Recepcion de bien de consumo eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  def eliminar_bien_de_recepcion
    @bienes_de_consumo_de_recepcion = BienDeConsumoDeRecepcion.find(params[:bien_de_consumo_id])
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo_id])                                                                                               
    @bienes_de_consumo_de_recepcion.destroy
    respond_to do |format|    
      flash[:notice] ='El bien de consumo fue eliminado exitosamente.' 
      format.html { redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path @recepcion_de_bien_de_consumo}                    

      format.json { head :no_content }
    end
  end

  def obtener_nombre_de_bien_de_consumo              
      @array_bien_de_consumo = BienDeConsumo.where(codigo: params[:codigo])
      @id_de_bien = @array_bien_de_consumo[0].id
      #@bien_de_consumo = BienDeConsumo.find(@id_de_bien)
      
      respond_to do | format |                  
          #format.json { render :json => @bien_de_consumo }        
          format.json { render :json => @array_bien_de_consumo }        
      end
  end

  def pegar_campo_descripcion_provisoria
        render(:partial => 'descripcion_provisoria')                                  
  end

  def enviar_a_evaluar
  @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])   
    respond_to do |format|                                                                                       
      if @recepcion_de_bien_de_consumo.estado == 1                
          if @recepcion_de_bien_de_consumo.update(estado: "3")        
            format.html { redirect_to recepciones_de_bien_de_consumo_url, notice: 'La Recepcion fue enviada a evaluacion exitosamente.' }          
          else     
            format.html { redirect_to recepciones_de_bien_de_consumo_url, notice: 'Error. La Recepcion no pudo ser enviada a evaluar.' }          
          end
          format.json { head :no_content }            
      else
        format.html { redirect_to recepciones_de_bien_de_consumo_url, notice: 'La Recepcion no es definitiva. No puede ser enviada a evaluar.' }
      end
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recepcion_de_bien_de_consumo
      @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recepcion_de_bien_de_consumo_params
      #params.require(:recepcion_de_bien_de_consumo).permit(:fecha, :estado, :descripcion_provisoria, :documento_principal, 
      #:documentos_secundario, bienes_de_consumo_de_recepcion_attributes: [:cantidad, :costo, bien_de_consumo_attributes: [:id]]) 
      params.require(:recepcion_de_bien_de_consumo).permit!           
    end
end
