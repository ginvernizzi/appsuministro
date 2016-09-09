class RegistroIngresoManualController < ApplicationController

	def index
    @registros = RegistroIngresoManual.all.paginate(:page => params[:page], :per_page => 30)
  end

	def traer_ingresos_manuales

		fecha_inicio = DateTime.parse(params[:fecha_inicio]).beginning_of_day()
    fecha_fin = DateTime.parse(params[:fecha_fin]).at_end_of_day()

		@registros = RegistroIngresoManual. where("created_at BETWEEN ? AND ?", fecha_inicio, fecha_fin).paginate(:page => params[:page], :per_page => 30)

		respond_to do |format|
			format.js {}
		end
	end

end
