require_dependency "vinculacion/application_controller"

module Vinculacion
  class ServiciosController < ApplicationController
  	def index
      results = Servicio.order(:id)
      render json: results
    end

    def show
      render json: Servicio.find(params[:id])
    end

    def create
      render json: Servicio.create(servicio)
    end

    def update
      render json: Servicio.find(params[:id]).tap { |b| b.update_attributes(servicio) }
    end

    def destroy
      render json: Servicio.find(params[:id]).destroy
    end

    protected
    def servicio
      params[:servicio].permit(:solicitud_id,
                                :nombre,
                                :descripcion,
                                :empleado_id)
    end
  end
end
