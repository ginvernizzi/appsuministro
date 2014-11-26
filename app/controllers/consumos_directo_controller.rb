class ConsumosDirectoController < ApplicationController
  before_action :set_consumo_directo, only: [:show, :edit, :update, :destroy]

  # GET /consumos_directo
  # GET /consumos_directo.json
  def index
    @consumos_directo = ConsumoDirecto.all
  end

  # GET /consumos_directo/1
  # GET /consumos_directo/1.json
  def show
  end

  # GET /consumos_directo/new
  def new
    @consumo_directo = ConsumoDirecto.new    
  end
    
  def nuevo_consumo_directo_desde_recepcion
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_id])
    @consumo_directo = ConsumoDirecto.new   
    cargar_datos_controles_consumo_directo
  end

  # GET /consumos_directo/1/edit
  def edit    
  end

  # POST /consumos_directo
  # POST /consumos_directo.json
  def create    
    @consumo_directo = ConsumoDirecto.new(consumo_directo_params)
    
    @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])

    @recepcion_de_bien_de_consumo.bienes_de_consumo_de_recepcion.each do |bien| 
      @consumo_directo.bienes_de_consumo_para_consumir.build(cantidad: bien.cantidad, costo: bien.costo, 
                                                               bien_de_consumo_id: bien.bien_de_consumo_id)


      @costo_de_bien = CostoDeBienDeConsumo.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,        
                                                usuario: "gonzalo", origen: "2" )

      @costo_de_bien_historico = CostoDeBienDeConsumoHistorico.new(fecha: DateTime.now, bien_de_consumo_id: bien.bien_de_consumo_id, costo: bien.costo,
                                                usuario: "gonzalo", origen: "2" )
    end


    respond_to do |format|
      if @consumo_directo.save
        format.html { redirect_to @consumo_directo, notice: 'Consumo directo creado exitosamente' }
        format.json { render :show, status: :created, location: @consumo_directo }
      else
        @recepcion_de_bien_de_consumo = RecepcionDeBienDeConsumo.find(params[:recepcion_de_bien_de_consumo][:id])
        cargar_datos_controles_consumo_directo
        format.html { render :nuevo_consumo_directo_desde_recepcion }
        format.json { render json: @consumo_directo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumos_directo/1
  # PATCH/PUT /consumos_directo/1.json
  def update
    respond_to do |format|
      if @consumo_directo.update(consumo_directo_params)
        format.html { redirect_to @consumo_directo, notice: 'Consumo directo was successfully updated.' }
        format.json { render :show, status: :ok, location: @consumo_directo }
      else
        format.html { render :edit }
        format.json { render json: @consumo_directo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumos_directo/1
  # DELETE /consumos_directo/1.json
  def destroy
    @consumo_directo.destroy
    respond_to do |format|
      format.html { redirect_to consumos_directo_url, notice: 'Consumo directo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumo_directo
      @consumo_directo = ConsumoDirecto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consumo_directo_params
      params.require(:consumo_directo).permit(:fecha, :area, :obra_proyecto_id)
    end

    def cargar_datos_controles_consumo_directo        
      @obras_proyecto = ObraProyecto.all      
      @areas = ["sistemas", "compras", "tesoreria"]
    end
end
