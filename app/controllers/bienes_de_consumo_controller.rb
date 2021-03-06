class BienesDeConsumoController < ApplicationController
  before_action :set_bien_de_consumo, only: [:show, :destroy, :edit, :update]
  before_action :set_back_page, only: [:show, :new, :traer_vista_dar_de_baja_y_reemplazar]

  def index
    @bienes_de_consumo = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)
  end

  def autocomplete_bien_de_consumo_nombre_traer_todos_los_items
    #clase_id = params[:clase_id]
    respond_to do |format|
      #if clase_id != ""
        @bienes = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.nombre ILIKE ?", "%#{params[:term]}%").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)
        render :json => @bienes.map { |bien| {:id => bien.id, :label => bien.nombre, :value => bien.nombre} }
      #end
      format.js { }
    end
  end

  def new
  	@bien_de_consumo = BienDeConsumo.new
  	@incisos = Inciso.all
	  @partidas_principales = PartidaPrincipal.all
  	@partidas_parciales = PartidaParcial.all
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
  	@bienes_de_consumo = BienDeConsumo.all
  end

  def edit
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
  end

  def show
  end

  def ver_items_dados_de_baja
    @bienes_de_consumo = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NOT NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)
  end

  def traer_vista_de_categoria
    categoria = params[:categoria]


    respond_to do |format|
		case categoria
		when "inciso"
	  		@inciso = Inciso.new
		when "partida_principal"
	  		@partida_principal = PartidaPrincipal.new
		when "partida_parcial"
			@partida_parcial = PartidaParcial.new
		when "clase"
	  		@clase = Clase.new
		else
			@clase_id = params[:id]
	  		@bien_de_consumo = BienDeConsumo.new
	  		format.js { render :action => 'traer_vista_de_bien_de_consumo' }
		end
	end
  end

  def create
    @bien_de_consumo = BienDeConsumo.new(bien_de_consumo_params)

    respond_to do |format|
      if @bien_de_consumo.save
        format.html { redirect_to new_bien_de_consumo_path(@area), notice: 'El Bien de consumo fue agregado exitosamente.' }
        #format.json { render :show, status: :created, location: @bien_de_consumo }

      else
        @incisos = Inciso.all
  		  @partidas_principales = PartidaPrincipal.all
    		@partidas_parciales = PartidaParcial.all
    		@clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
    		@bienes_de_consumo = BienDeConsumo.all

  		#format.html { render :new }
        # format.html { render :partial => "/bienes_de_consumo/form_bien_de_consumo" }
        #format.js { render :action => 'traer_vista_de_bien_de_consumo' }
        format.html { render :new }
        format.json { render json: @bien_de_consumo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bien_de_consumo.update(bien_de_consumo_params)
        format.html { redirect_to bien_de_consumo_path (@bien_de_consumo), notice: 'El item fué modficado exitosamente.' }
        format.json { render :show, status: :ok, location: @bien_de_consumo }
      else
        @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
        format.html { render :edit }
        format.json { render json: @bien_de_consumo.errors, status: :unprocessable_entity }
      end
    end
  end


  def traer_clases_con_codigo_de_bien_existente
    codigo = params[:codigo]
    @clases = Clase.joins(:bienes_de_consumo).where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.codigo = ?", codigo)

    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js { }
    end
  end


  def traer_items_de_la_clase
    clase_id = params[:clase_id]
    @bienes = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.clase_id = ?", clase_id).order("bienes_de_consumo.codigo")

    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js { }
    end
  end


  def traer_clases_con_nombre_de_bien_de_consumo_similar
    nombre = params[:nombre]
    @clases = Clase.joins(:bienes_de_consumo).where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.nombre ILIKE ?", "%#{nombre}%")

    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js { }
    end
  end

  def destroy
    respond_to do |format|
      if @bien_de_consumo.update(fecha_de_baja: DateTime.now)
        flash[:notice] = 'El Bien de consumo fue dado de baja exitosamente.'
      else
        flash[:notice] = 'Ha ocurrido un error. El Bien de consumo no pudo ser dado de baja'
      end

      format.html { redirect_to bienes_de_consumo_path }
      format.json { head :no_content }
    end
  end

  def traer_vista_dar_de_baja_y_reemplazar
    @clases = Clase.joins(:partida_parcial => [:partida_principal]).where("clases.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo")
    @bien_de_consumo = BienDeConsumo.new
  end

  def dar_de_baja_y_reemplazar_bienes_de_consumo
    @bien_de_consumo_erroneo = BienDeConsumo.find(params[:bien_de_consumo_id])
    @bien_de_consumo = BienDeConsumo.new(bien_de_consumo_params)

    respond_to do |format|
        if guardar_cambio
          format.html { redirect_to bienes_de_consumo_path, notice: 'Se ha reemplazado el Bien de consumo exitosamente.' }
        else
          @bien_de_consumo_erroneo.update(fecha_de_baja: nil)
          @clases = Clase.where("clases.fecha_de_baja IS NULL")
          @bienes_de_consumo = BienDeConsumo.where("bienes_de_consumo.fecha_de_baja IS NULL")

          format.html { render :traer_vista_dar_de_baja_y_reemplazar }
          format.json { render json: @bien_de_consumo.errors, status: :unprocessable_entity }
        end
    end
  end

  def guardar_cambio
    ActiveRecord::Base.transaction do
        @bien_de_consumo_erroneo.saltear_codigo_de_item_existente = true
        @bien_de_consumo_erroneo.update(fecha_de_baja: DateTime.now)
        @bien_de_consumo.save

        @reemplazo_bdc = ReemplazoBdc.new(bdc_viejo_id:@bien_de_consumo_erroneo.id, bdc_nuevo_id:@bien_de_consumo.id)
        @reemplazo_bdc.save

        costo_viejo_array = CostoDeBienDeConsumo.where("bien_de_consumo_id = ?", @bien_de_consumo_erroneo.id).last()

        items_stock_viejo_array = ItemStock.where("bien_de_consumo_id = ?", @bien_de_consumo_erroneo.id)

        costo_nuevo = guardar_costo_manualmente(@bien_de_consumo.id, costo_viejo_array.costo)
        costo_historico_nuevo =  guardar_costo_historico(@bien_de_consumo.id, costo_viejo_array.costo)

        items_stock_viejo_array.each do |item|
          item.update(:bien_de_consumo_id => @bien_de_consumo.id, :costo_de_bien_de_consumo_id => costo_nuevo.id)
        end
    end
  end

  def existen_stocks_minimos_superados
    resp = false

    @items = @items = ItemStock.joins(:bien_de_consumo).where("cantidad < bienes_de_consumo.stock_minimo")

    respond_to do |format|
    if @items.count > 0
      resp = true
    end

    format.json {
      render json: {:data => resp}
    }
    end
  end

  def traer_item_por_id
    bien_de_consumo_id = params[:bien_de_consumo_id]

    @bienes_de_consumo = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL AND bienes_de_consumo.id = ?", bien_de_consumo_id).order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)

    #pass @reportes_a_fecha to index.html.erb and update only the tbody with id=content which takes @query
    #render :partial => 'form_tabla_stock'
    respond_to do |format|
      format.js {}
    end
  end

  def traer_todos_los_items
    @bienes_de_consumo = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo").paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      format.js{}
    end
  end

  def imprimir_listado_de_items
    @generador = GeneradorDeImpresionListadoDeItems.new
    @items = BienDeConsumo.joins(:clase => [:partida_parcial => [:partida_principal]]).where("bienes_de_consumo.fecha_de_baja IS NULL").order("partidas_principales.codigo").order("partidas_parciales.codigo").order("clases.codigo").order("bienes_de_consumo.codigo")
    @generador.generar_pdf_listado_de_items(@items)
    file = Rails.root.join("public/forms_impresiones/" +  @generador.nombre_formulario_listado_items_pdf)
    send_file ( file )
  end

  def traer_costo_de_bien_de_consumo
    bien_id = params[:bien_id]
    @costo_de_bien = nil

    if !bien_id.nil?
      @costo_de_bien = CostoDeBienDeConsumo.where("bien_de_consumo_id = ?", bien_id).last
      @costo_de_bien = @costo_de_bien["costo"] unless @costo_de_bien.nil?
    end

    respond_to do | format |
          format.json { render :json => @costo_de_bien }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bien_de_consumo
  	@bien_de_consumo = BienDeConsumo.find(params[:id])
  end

  def set_back_page
    session[:return_to] ||= request.referer
  end

  def bien_de_consumo_params
	params.require(:bien_de_consumo).permit(:nombre, :codigo, :detalle_adicional, :unidad_de_medida, :clase_id, :fecha, :stock_minimo)
  end

  def guardar_costo_manualmente(bien_de_consumo_id, costo)
    nuevo_costo = CostoDeBienDeConsumo.new
    nuevo_costo = CostoDeBienDeConsumo.create(bien_de_consumo_id: bien_de_consumo_id, fecha: DateTime.now, costo: costo, usuario: current_user.name, origen: '2')
    return nuevo_costo
  end

    def guardar_costo_historico(bien_de_consumo_id, costo)
    nuevo_costo = CostoDeBienDeConsumoHistorico.new
    nuevo_costo = CostoDeBienDeConsumoHistorico.create(bien_de_consumo_id: bien_de_consumo_id, fecha: DateTime.now, costo: costo, usuario: current_user.name, origen: '2')
    return nuevo_costo
  end

end
