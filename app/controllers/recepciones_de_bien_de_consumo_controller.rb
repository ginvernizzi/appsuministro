class RecepcionesDeBienDeConsumoController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo, only: [:show, :edit, :update, :destroy]

  # GET /recepciones_de_bien_de_consumo
  # GET /recepciones_de_bien_de_consumo.json
  def index
    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.all
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
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new(fecha: params[:recepcion_de_bien_de_consumo][:fecha], estado: params[:recepcion_de_bien_de_consumo][:estado], 
                                                                 descripcion_provisoria: params[:recepcion_de_bien_de_consumo][:descripcion_provisoria])  
    
    @tddp = TipoDeDocumento.find_by_id(params[:tdp][:tipo_de_documento_id])    
    

    @docRecepcion_p = DocumentoDeRecepcion.new(numero_de_documento: params[:numero_doc_principal], tipo_de_documento: @tddp)
    

    @recepcion_de_bien_de_consumo.build_documento_principal(documento_de_recepcion:@docRecepcion_p, 
                                       recepcion_de_bien_de_consumo: @recepcion_de_bien_de_consumo)

    #Key (tipoDeDocumento_Id) Value (numero de documento)

      if params[:ltds] 
          params[:ltds].each { |k, v|          
            if (k.include? "numero_doc_secundario")
            @tdds = TipoDeDocumento.find_by_id(k)
            @docRecepcion_s = DocumentoDeRecepcion.new(numero_de_documento: v, tipo_de_documento: @tdds)
            @recepcion_de_bien_de_consumo.documentos_secundario.new(documento_de_recepcion: @docRecepcion_s,
                                                                  recepcion_de_bien_de_consumo: @recepcion_de_bien_de_consumo)
            end                                                                                    
          }
      end
                    
      if @recepcion_de_bien_de_consumo.save                              
        redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path(@recepcion_de_bien_de_consumo)        
        #format.html { render :new_bienes}
        #format.html { render :new }
      else        
        respond_to do |format|  
          @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new
          @tipos_de_documento = TipoDeDocumento.all
          format.html { render :new }
          format.json { render json: @recepcion_de_bien_de_consumo.errors, status: :unprocessable_entity }
        end
      end
  end

  def new_bienes
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])  
  end

  def save_bienes        
    
    @bdc = BienDeConsumo.where(nombre: params[:nombre]) 
     
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])  
          
    @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.build(cantidad: params[:cantidad], costo: params[:costo], bien_de_consumo: @bdc[0])    
        
    
      if @recepcion_de_bien_de_consumo.save     
         flash[:notice] = 'Bien de consumo agregado exitosamente.'
         redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path @recepcion_de_bien_de_consumo
      else
        respond_to do |format|
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
        format.html { redirect_to @recepcion_de_bien_de_consumo, notice: 'Recepcion de bien de consumo was successfully updated.' }
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
      format.html { redirect_to recepciones_de_bien_de_consumo_url, notice: 'Recepcion de bien de consumo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_bien_de_consumo_rececpcion
    @bienes_de_consumo_de_recepcion.destroy
    respond_to do |format|
      format.html { redirect_to agregar_bienes_recepciones_de_bien_de_consumo_path @recepcion_de_bien_de_consumo, notice: 'El bien de consumo fue eliminado exitosamente.' }
      format.json { head :no_content }
    end
  end

  def pegar_campo_factura
      render(:partial => 'numero_factura')       
  end


  def pegar_campo_orden_de_compra
      render(:partial => 'numero_oc')       
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recepcion_de_bien_de_consumo
      @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recepcion_de_bien_de_consumo_params
      params.require(:recepcion_de_bien_de_consumo).permit(:fecha, :estado, :descripcion_provisoria, :numero_doc_principal, :numero_doc_secundario)
    end
end
