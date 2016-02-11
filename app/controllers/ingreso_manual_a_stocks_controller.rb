class IngresoManualAStocksController < ApplicationController
  before_action :set_ingreso_manual_a_stock, only: [:show, :edit, :update, :destroy]

  # GET /ingreso_manual_a_stocks
  # GET /ingreso_manual_a_stocks.json
  def index
    @ingreso_manual_a_stocks = IngresoManualAStock.all
  end

  # GET /ingreso_manual_a_stocks/1
  # GET /ingreso_manual_a_stocks/1.json
  def show
  end

  # GET /ingreso_manual_a_stocks/new
  def new
    @ingreso_manual_a_stock = IngresoManualAStock.new
    @ingreso_manual_a_stock.items_stock.build
  end

  # GET /ingreso_manual_a_stocks/1/edit
  def edit
      @ingreso_manual_a_stock.items_stock.build
  end

  # POST /ingreso_manual_a_stocks
  # POST /ingreso_manual_a_stocks.json
  def create
    @ingreso_manual_a_stock = IngresoManualAStock.new(ingreso_manual_a_stock_params)

    respond_to do |format|
      if @ingreso_manual_a_stock.save
        format.html { redirect_to @ingreso_manual_a_stock, notice: 'Ingreso manual a stock was successfully created.' }
        format.json { render :show, status: :created, location: @ingreso_manual_a_stock }
      else
        format.html { render :new }
        format.json { render json: @ingreso_manual_a_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingreso_manual_a_stocks/1
  # PATCH/PUT /ingreso_manual_a_stocks/1.json
  def update
    respond_to do |format|
      if @ingreso_manual_a_stock.update(ingreso_manual_a_stock_params)
        format.html { redirect_to @ingreso_manual_a_stock, notice: 'Ingreso manual a stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingreso_manual_a_stock }
      else
        format.html { render :edit }
        format.json { render json: @ingreso_manual_a_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingreso_manual_a_stocks/1
  # DELETE /ingreso_manual_a_stocks/1.json
  def destroy
    @ingreso_manual_a_stock.destroy
    respond_to do |format|
      format.html { redirect_to ingreso_manual_a_stocks_url, notice: 'Ingreso manual a stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingreso_manual_a_stock
      @ingreso_manual_a_stock = IngresoManualAStock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ingreso_manual_a_stock_params
      params.require(:ingreso_manual_a_stock).permit(:fecha, items_stock_attributes: [ :ingreso_manual_a_stock_id, :bien_de_consumo_id, :cantidad, :costo ])
    end
end
