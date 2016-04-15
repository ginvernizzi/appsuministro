class RecepcionesDeBienDeConsumoEnStockController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo_en_stock, only: [:show]

  autocomplete :bien_de_consumo, :nombre , :full => true
  #autocomplete :documento_principal, :nombre , :full => true

  # def autocomplete_documento_principal_nombre
  #   @documentos = DocumentoPrincipal.joins(:documento_de_recepcion, :recepcion_de_bien_de_consumo).where("documentos_de_recepcion.numero_de_documento ILIKE ? AND (recepciones_de_bien_de_consumo.estado = ? OR recepciones_de_bien_de_consumo.estado = ?)", "%#{params[:term]}%", 5, 6)
  #   respond_to do |format|
  #     format.html
  #     format.json { render json: @documentos.map{|x| x.documento_de_recepcion.numero_de_documento } }
  #   end    
  # end
  
  def index  	 
  end


  def show
  end

  def traer_recepciones_por_doc_principal
    documento_principal = params[:documento_principal]    

   if !documento_principal.nil? 
      @recepciones_de_bien_de_consumo = query_recepciones_finalizadas_por_documento_principal(documento_principal);
    else
      @recepciones_de_bien_de_consumo = nil
    end
          
    respond_to do |format|   
      format.js {}
    end 
  end

  def imprimir_detalle_recepcion
    recepcion_id = params[:recepciones_de_bien_de_consumo_en_stock_id]  
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new

    if !recepcion_id.nil?
      @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(recepcion_id)      
    end

    @generador = GeneradorDeImpresionRecepcion.new
    @generador.generar_pdf_detalle_de_recepcion(@recepcion_de_bien_de_consumo)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_detalle_de_recepcion_pdf)
    send_file ( file ) 
  end


  def ver_recepciones_finalizadas_por_bien_de_consumo_y_fecha

  end

  def traer_recepciones_por_bien_y_fecha
    bien_id = params[:bien_id]    
    fecha_inicio =  DateTime.parse(params[:fecha_inicio]).beginning_of_day()    
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day()     
    @recepciones_de_bien_de_consumo = nil


    begin
      if !bien_id.nil? && !bien_id.blank? && !fecha_inicio.nil? && !fecha_fin.nil?
          @recepciones_de_bien_de_consumo = query_recepciones_finalizadas_por_bien_y_fecha(bien_id, fecha_inicio, fecha_fin);
          if @recepciones_de_bien_de_consumo.count > 0
             @recepciones_de_bien_de_consumo[0].fecha_inicio = params[:fecha_inicio];
             @recepciones_de_bien_de_consumo[0].fecha_fin = params[:fecha_fin];
             @recepciones_de_bien_de_consumo[0].bien_de_consumo_id = params[:bien_id];
          end     
      end

      rescue Exception
    end
          
    respond_to do |format|   
      format.js {}
    end 
  end

  def imprimir_formulario_recepciones_finalizadas_por_bien_y_fecha
    bien_id = params[:bien_id]    
    fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()  
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day() 

    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.new

    if !documento_principal.nil? && !fecha_inicio.nil? && !fecha_fin.nil?
      @recepciones_de_bien_de_consumo = query_recepciones_finalizadas_por_bien_y_fecha(bien_id, fecha_inicio, fecha_fin);
    end

    @generador = GeneradorDeImpresionRecepcion.new
    @generador.generar_pdf_recepcion(@recepciones_de_bien_de_consumo)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_recepcion_pdf)
    send_file ( file )  
  end

    def imprimir_formulario_recepciones_por_documento_principal    
    documento_principal =params[:documento_principal]       

    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.new

    if !documento_principal.nil?
      @recepciones_de_bien_de_consumo = query_recepciones_finalizadas_por_documento_principal(documento_principal)
    end

    @generador = GeneradorDeImpresionRecepcion.new
    @generador.generar_pdf_recepcion(@recepciones_de_bien_de_consumo)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_recepcion_pdf)
    send_file ( file )         
  end

  private

  def query_recepciones_finalizadas_por_docuemnto_principal_y_fecha(documento_principal, fecha_inicio, fecha_fin)
    #Estado finalizado = 8
    RecepcionDeBienDeConsumo.joins(documento_principal: :documento_de_recepcion).where("numero_de_documento = ? AND fecha BETWEEN ? AND ? AND estado = ? ", documento_principal, fecha_inicio, fecha_fin, 8)        
  end
  
  def query_recepciones_finalizadas_por_documento_principal(documento_principal)
    #Estado finalizado = 8
    RecepcionDeBienDeConsumo.joins(documento_principal: :documento_de_recepcion).where("numero_de_documento = ? AND estado = ? ", documento_principal, 8)        
  end

  def query_recepciones_finalizadas_por_bien_y_fecha(bien_id, fecha_inicio, fecha_fin)
    #Estado finalizado = 8
    RecepcionDeBienDeConsumo.joins(:bienes_de_consumo_de_recepcion).where("bienes_de_consumo_de_recepcion.bien_de_consumo_id = ? AND fecha BETWEEN ? AND ? AND estado = ? ", bien_id, fecha_inicio, fecha_fin, 8)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_recepcion_de_bien_de_consumo_en_stock
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])
  end

 end