class RegistroIngresoManualController < ApplicationController

	def index
    @registros = RegistroIngresoManual.all.paginate(:page => params[:page], :per_page => 30)        
  end
end
