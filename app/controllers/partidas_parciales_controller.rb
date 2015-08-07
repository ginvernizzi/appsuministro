 class PartidasParcialesController < ApplicationController
  before_action :set_partida_parcial, only: [:show, :edit, :update, :destroy]

  # GET /partidas_parciales
  # GET /partidas_parciales.json
  def index
    @partidas_parciales = PartidaParcial.includes(:partida_principal).order("partidas_principales.codigo").order("partidas_parciales.codigo").paginate(:page => params[:page], :per_page => 30)                          
  end

  # GET /partidas_parciales/1
  # GET /partidas_parciales/1.json
  def show
  end

  # GET /partidas_parciales/new
  def new
    @partida_parcial = PartidaParcial.new
    @partidas_principales = PartidaPrincipal.all    
  end

  # GET /partidas_parciales/1/edit
  def edit
    @partidas_principales = PartidaPrincipal.all  
  end

  # POST /partidas_parciales
  # POST /partidas_parciales.json
  def create
    @partida_parcial = PartidaParcial.new(partida_parcial_params)

    respond_to do |format|
      if @partida_parcial.save
        format.html { redirect_to @partida_parcial, notice: 'La Partida parcial fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @partida_parcial }
      else
        @partidas_principales = PartidaPrincipal.all  
        format.html { render :new }
        format.json { render json: @partida_parcial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partidas_parciales/1
  # PATCH/PUT /partidas_parciales/1.json
  def update
    respond_to do |format|
      if @partida_parcial.update(partida_parcial_params)
        format.html { redirect_to @partida_parcial, notice: 'La Partida parcial fue modificada exitosamente.' }
        format.json { render :show, status: :ok, location: @partida_parcial }
      else
        @partidas_principales = PartidaPrincipal.all  
        format.html { render :edit }
        format.json { render json: @partida_parcial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partidas_parciales/1
  # DELETE /partidas_parciales/1.json
  def destroy
    respond_to do |format|
      if @partida_parcial.destroy    
        format.html { redirect_to partidas_parciales_url, notice: 'La Partida parcial fue eliminada exitosamente.' }
        format.json { head :no_content }      
      else
        format.html { redirect_to partidas_principales_url, notice: @partida_parcial.errors[:base].to_s }
      end  
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partida_parcial
      @partida_parcial = PartidaParcial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partida_parcial_params
      params.require(:partida_parcial).permit(:codigo, :nombre, :partida_principal_id)
    end
end
