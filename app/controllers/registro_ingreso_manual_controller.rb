class RegistroIngresoManualController < ApplicationController

	def index
    @registros = RegistroIngresoManual.all
  end
end
