class IncisosController < ApplicationController
  before_action :set_inciso, only: [:show, :edit, :update, :destroy]

  # GET /incisos
  # GET /incisos.json
  def index
    @incisos = Inciso.all
  end

  # GET /incisos/1
  # GET /incisos/1.json
  def show
  end

  # GET /incisos/new
  def new
    @inciso = Inciso.new
  end

  # GET /incisos/1/edit
  def edit
  end

  # POST /incisos
  # POST /incisos.json
  def create
    @inciso = Inciso.new(inciso_params)

    respond_to do |format|
      if @inciso.save
        format.html { redirect_to @inciso, notice: 'El Inciso fue creado exitosamente.' }
        format.json { render :show, status: :created, location: @inciso }
      else
        format.html { render :new }
        format.json { render json: @inciso.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incisos/1
  # PATCH/PUT /incisos/1.json
  def update
    respond_to do |format|
      if @inciso.update(inciso_params)
        format.html { redirect_to @inciso, notice: 'El Inciso fue modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @inciso }
      else
        format.html { render :edit }
        format.json { render json: @inciso.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incisos/1
  # DELETE /incisos/1.json
  def destroy
    respond_to do |format|
      if @inciso.destroy    
        format.html { redirect_to incisos_url, notice: 'El Inciso fue eliminado exitosamente.' }
        format.json { head :no_content }
      else
        format.html { redirect_to incisos_url, notice: @clase.errors[:base].to_s }
        format.json { render json: @inciso.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inciso
      @inciso = Inciso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inciso_params
      params.require(:inciso).permit(:codigo, :nombre)
    end
end
