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
  end

  # GET /recepciones_de_bien_de_consumo/1/edit
  def edit
  end

  # POST /recepciones_de_bien_de_consumo
  # POST /recepciones_de_bien_de_consumo.json
  def create
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.new(recepcion_de_bien_de_consumo_params)

    respond_to do |format|
      if @recepcion_de_bien_de_consumo.save
        format.html { redirect_to @recepcion_de_bien_de_consumo, notice: 'Recepcion de bien de consumo was successfully created.' }
        format.json { render :show, status: :created, location: @recepcion_de_bien_de_consumo }
      else
        format.html { render :new }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recepcion_de_bien_de_consumo
      @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recepcion_de_bien_de_consumo_params
      params.require(:recepcion_de_bien_de_consumo).permit(:fecha, :estado, :descripcion_provisoria)
    end
end
