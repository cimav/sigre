require_dependency "vinculacion/application_controller"

module Vinculacion
  class SolicitudesController < ApplicationController
  	def index
      render json: Solicitud.all
    end

    def show
      render json: Solicitud.find(params[:id])
    end

    def create
      render json: Solicitud.create(solicitud)
    end

    def update
      render json: Solicitud.find(params[:id]).tap { |b| b.update_attributes(solicitud) }
    end

    def destroy
      render json: Solicitud.find(params[:id]).destroy
    end

    protected
    def solicitud
      params[:solicitud].permit(:consecutivo,
                                :codigo,
                                :tipo,
                                :proyecto_id,
                                :sede_id,
                                :prioridad,
                                :cliente_id,
                                :contacto_id,
                                :contacto_email,
                                :notas,
                                :acuerdos,
                                :usuario_id,
                                :status)
    end
  end
end
