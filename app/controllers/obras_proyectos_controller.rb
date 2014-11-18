class ObrasProyectosController < ApplicationController
  before_action :set_obra_proyecto, only: [:show, :edit, :update, :destroy]

  # GET /obras_proyectos
  # GET /obras_proyectos.json
  def index
    @obras_proyectos = ObraProyecto.all
  end

  # GET /obras_proyectos/1
  # GET /obras_proyectos/1.json
  def show
  end

  # GET /obras_proyectos/new
  def new
    @obra_proyecto = ObraProyecto.new
  end

  # GET /obras_proyectos/1/edit
  def edit
  end

  # POST /obras_proyectos
  # POST /obras_proyectos.json
  def create
    @obra_proyecto = ObraProyecto.new(obra_proyecto_params)

    respond_to do |format|
      if @obra_proyecto.save
        format.html { redirect_to @obra_proyecto, notice: 'La obra/poryecto fue creada exitosamente.' }
        format.json { render :show, status: :created, location: @obra_proyecto }
      else
        format.html { render :new }
        format.json { render json: @obra_proyecto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /obras_proyectos/1
  # PATCH/PUT /obras_proyectos/1.json
  def update
    respond_to do |format|
      if @obra_proyecto.update(obra_proyecto_params)
        format.html { redirect_to @obra_proyecto, notice: 'La obra/poryecto fue actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @obra_proyecto }
      else
        format.html { render :edit }
        format.json { render json: @obra_proyecto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /obras_proyectos/1
  # DELETE /obras_proyectos/1.json
  def destroy
    @obra_proyecto.destroy
    respond_to do |format|
      format.html { redirect_to obras_proyectos_url, notice: 'La obra/poryecto fue eliminada exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_obra_proyecto
      @obra_proyecto = ObraProyecto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def obra_proyecto_params
      params.require(:obra_proyecto).permit(:codigo, :descripcion)
    end
end
