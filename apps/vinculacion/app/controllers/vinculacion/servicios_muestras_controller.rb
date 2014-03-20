require_dependency "vinculacion/application_controller"

module Vinculacion
  class ServiciosMuestrasController < ApplicationController
  	def index
      results = ServiciosMuestras.order(:id)
      render json: results
    end

    def show
      render json: ServiciosMuestras.find(params[:id])
    end

    def create
      render json: ServiciosMuestras.create(servicios_muestras)
    end

    def update
      render json: ServiciosMuestras.find(params[:id]).tap { |b| b.update_attributes(servicios_muestras) }
    end

    def destroy
      render json: ServiciosMuestras.find(params[:id]).destroy
    end

    protected
    def servicios_muestras
      params[:servicios_muestras].permit(:servicio_id,
                                :muestra_id)
    end
  end
end
