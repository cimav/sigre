require_dependency "vinculacion/application_controller"

module Vinculacion
  class SolicitudesController < ApplicationController
  	def index
      results = Solicitud.includes(:proyecto).order(:id)
      if !params[:q].blank?
        results = results.where("(descripcion LIKE :q OR vinculacion_proyectos.nombre LIKE :q)", {:q => "%#{params[:q]}%"})
      end
      render json: results
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
                                :proyecto_id,
                                :sede_id,
                                :prioridad,
                                :cliente_id,
                                :contacto_id,
                                :descripcion,
                                :usuario_id,
                                :status,
                                :motivo_status,
                                :razon_cancelacion,
                                :orden_compra,
                                :fecha_inicio,
                                :fecha_termino
      )
    end
  end
end
