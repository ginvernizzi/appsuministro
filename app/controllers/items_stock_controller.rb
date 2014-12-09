class ItemsStockController < ApplicationController
  # before_action :set_item_stock, only: [:show, :edit, :update, :destroy]

  def index
  	@items_stock = ItemStock.all
  end

  def new
  	@item_stock = ItemStock.new
  end

  def ver_ingresar_a_stock
	 @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_id])	
	 @areas = Area.all
	 @depositos = Deposito.all
	 @item_stock = ItemStock.new   
  end

  def create

  end

  private 

  def consumo_directo_params
    params.require(:item_stock).permit(:cantidad, :costo)
  end
end
