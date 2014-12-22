class RecepcionesDeBienDeConsumoEnStockController < ApplicationController
  before_action :set_recepcion_de_bien_de_consumo_en_stock, only: [:show]

  def index
  	 @recepciones_de_bien_de_consumo = RecepcionDeBienDeConsumo.where(estado: 6).order(:id)
  end


  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_recepcion_de_bien_de_consumo_en_stock
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])
  end

 end