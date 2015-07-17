class PartidasPrincipalesController < ApplicationController
  before_action :set_partida_principal, only: [:show, :edit, :update, :destroy]

  # GET /partidas_principales
  # GET /partidas_principales.json
  def index
    @partidas_principales = PartidaPrincipal.includes(:inciso).order("incisos.codigo").order("partidas_principales.codigo")      
  end

  # GET /partidas_principales/1
  # GET /partidas_principales/1.json
  def show
     @incisos = Inciso.all
  end

  # GET /partidas_principales/new
  def new
    @partida_principal = PartidaPrincipal.new
    @incisos = Inciso.all    
  end

  # GET /partidas_principales/1/edit
  def edit
      @incisos = Inciso.all 
  end

  # POST /partidas_principales
  # POST /partidas_principales.json
  def create
    @partida_principal = PartidaPrincipal.new(partida_principal_params)

    respond_to do |format|
      if @partida_principal.save
        format.html { redirect_to @partida_principal, notice: 'La Partida principal fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @partida_principal }
      else
        @incisos = Inciso.all
        format.html { render :new }
        format.json { render json: @partida_principal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partidas_principales/1
  # PATCH/PUT /partidas_principales/1.json
  def update
    respond_to do |format|
      if @partida_principal.update(partida_principal_params)
        format.html { redirect_to @partida_principal, notice: 'La Partida principal fue modificada exitosamente.' }
        format.json { render :show, status: :ok, location: @partida_principal }
      else
        format.html { render :edit }
        format.json { render json: @partida_principal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partidas_principales/1
  # DELETE /partidas_principales/1.json
    def destroy
    respond_to do |format|
      if @partida_principal.destroy    
        format.html { redirect_to partidas_principales_url, notice: 'La partida principal fue eliminada exitosamnte.' }
        format.json { head :no_content }
      else
        format.html { redirect_to partidas_principales_url, notice: @partida_principal.errors[:base].to_s }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partida_principal
      @partida_principal = PartidaPrincipal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partida_principal_params
      params.require(:partida_principal).permit(:codigo, :nombre, :inciso_id)
    end
end
