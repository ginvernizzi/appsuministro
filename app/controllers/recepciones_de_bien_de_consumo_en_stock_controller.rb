class RecepcionesDeBienDeConsumoEnStockController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo_en_stock, only: [:show]

  #autocomplete :documento_principal, :nombre , :full => true

  # def autocomplete_documento_principal_nombre
  #   @documentos = DocumentoPrincipal.joins(:documento_de_recepcion, :recepcion_de_bien_de_consumo).where("documentos_de_recepcion.numero_de_documento ILIKE ? AND (recepciones_de_bien_de_consumo.estado = ? OR recepciones_de_bien_de_consumo.estado = ?)", "%#{params[:term]}%", 5, 6)
  #   respond_to do |format|
  #     format.html
  #     format.json { render json: @documentos.map{|x| x.documento_de_recepcion.numero_de_documento } }
  #   end    
  # end
  
  def index
  	 #@recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where(estado: 6).order(:id)
     #ver la lista de recepciones ingresadas a stock y en consumo directo.
     #@recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where("estado = 5 OR estado = 6").order(:id)
  end


  def show
  end

  def traer_recepciones_por_fecha
    documento_principal = params[:documento_principal]    
    fecha_inicio = params[:fecha_inicio]  
    fecha_fin = params[:fecha_fin]   

   if !documento_principal.nil? && !fecha_inicio.nil? && !fecha_fin.nil?
      @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.joins(documento_principal: :documento_de_recepcion).where("numero_de_documento = ? AND estado = ? OR estado = ? AND fecha >= ? AND fecha <= ?", documento_principal, 5, 6,fecha_inicio, fecha_fin)
        if @recepciones_de_bien_de_consumo.count > 0
           @recepciones_de_bien_de_consumo[0].fecha_inicio = params[:fecha_inicio];
           @recepciones_de_bien_de_consumo[0].fecha_fin = params[:fecha_fin];
        end
    else
      @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.new
    end
          
    respond_to do |format|   
      format.js {}
    end 
  end

  
  def imprimir_formulario_recepciones_por_documento_principal_fecha    
    documento_principal = params[:documento_principal]    
    fecha_inicio = params[:fecha_inicio]  
    fecha_fin = params[:fecha_fin]   

    @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.new

    if !documento_principal.nil? && !fecha_inicio.nil? && !fecha_fin.nil?
      @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.joins(documento_principal: :documento_de_recepcion).where("numero_de_documento = ? AND estado = ? OR estado = ? AND fecha >= ? AND fecha <= ?", documento_principal, 5, 6,fecha_inicio, fecha_fin)        
    end

    @generador = GeneradorDeImpresionRecepcion.new
    @generador.generar_pdf_recepcion(@recepciones_de_bien_de_consumo)
    file = Rails.root.join("public/forms_impresiones/" + @generador.nombre_formulario_recepcion_pdf)
    send_file ( file )         
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recepcion_de_bien_de_consumo_en_stock
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])
  end

 end