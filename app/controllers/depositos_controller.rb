class DepositosController < ApplicationController
  before_action :set_deposito, only: [:show, :edit, :update, :destroy]

  # GET /depositos
  # GET /depositos.json
  def index
    @depositos = Deposito.all
  end

  # GET /depositos/1
  # GET /depositos/1.json
  def show
  end

  # GET /depositos/new
  def new
    @area = Area.find(params[:area_id])
    @deposito = Deposito.new(area_id: @area.id)
  end

  # GET /depositos/1/edit
  def edit
  end

  # POST /depositos
  # POST /depositos.json
  def create
    @area = Area.find(deposito_params[:area_id])
    @deposito = Deposito.new(deposito_params)

    respond_to do |format|
      if @deposito.save
        format.html { redirect_to new_area_deposito_path(@area), notice: 'El deposito fue agregado exitosamente.' }   
        format.json { render :show, status: :created, location: @deposito }

      else
        format.html { render :new }
        format.json { render json: @deposito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /depositos/1
  # PATCH/PUT /depositos/1.json
  def update
    respond_to do |format|
      if @deposito.update(deposito_params)
        format.html { redirect_to  areas_path, notice: 'El deposito fue modificado exitosamente.' }
        format.json { render :show, status: :ok, location: @deposito }
      else
        format.html { render :edit }
        format.json { render json: @deposito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /depositos/1
  # DELETE /depositos/1.json
  def destroy  
    ActiveRecord::Base.transaction do
      begin
        @area = Area.find(params[:area_id])
        @desposito = Deposito.find(params[:id])
        if @deposito.destroy
          flash[:notice] = 'El depósito fué eliminado exitosamente'
        end
      rescue ActiveRecord::InvalidForeignKey
        flash[:notice] = 'El depósito tiene relaciones asociadas. No pudo ser eliminado'
      end
      respond_to do |format|      
         format.html { redirect_to new_area_deposito_path(@area) } 
         format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deposito
    @deposito = Deposito.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def deposito_params
    params.require(:deposito).permit(:nombre, :area_id)
  end

end
