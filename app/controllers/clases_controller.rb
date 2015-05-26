class ClasesController < ApplicationController
  before_action :set_clase, only: [:show, :edit, :update, :destroy]

  # GET /clases
  # GET /clases.json
  def index
    @clases = Clase.includes(:partida_parcial).order("partidas_parciales.nombre")      
  end

  # GET /clases/1
  # GET /clases/1.json
  def show
  end

  # GET /clases/new
  def new
    @clase = Clase.new
    @partidas_parciales = PartidaParcial.all
  end

  # GET /clases/1/edit
  def edit
    @partidas_parciales = PartidaParcial.all
  end

  # POST /clases
  # POST /clases.json
  def create
    @clase = Clase.new(clase_params)

    respond_to do |format|
      if @clase.save
        format.html { redirect_to @clase, notice: 'La Clase fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @clase }
      else
        @partidas_parciales = PartidaParcial.all
        format.html { render :new }
        format.json { render json: @clase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clases/1
  # PATCH/PUT /clases/1.json
  def update
    respond_to do |format|
      if @clase.update(clase_params)
        format.html { redirect_to @clase, notice: 'La Clase fue modificada exitosamente.' }
        format.json { render :show, status: :ok, location: @clase }
      else
        @partidas_parciales = PartidaParcial.all
        format.html { render :edit }
        format.json { render json: @clase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clases/1
  # DELETE /clases/1.json
  def destroy
    respond_to do |format|
      if @clase.destroy    
        format.html { redirect_to clases_url, notice: 'La Clase fue eliminada exitosamnte.' }
        format.json { head :no_content }
      else
        format.html { redirect_to clases_url, notice: @clase.errors[:base].to_s }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clase
      @clase = Clase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clase_params
      params.require(:clase).permit(:codigo, :nombre, :partida_parcial_id)
    end
end
