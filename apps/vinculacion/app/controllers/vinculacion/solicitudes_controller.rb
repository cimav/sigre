require_dependency "vinculacion/application_controller"
require 'resque-bus'

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

    def notificar_cancelacion
      solicitud = Solicitud.find(params[:id])

      # notificar a Bitacora
      ResqueBus.redis = '127.0.0.1:6379' # TODO: Mover a config
      ResqueBus.publish('notificar_cancelacion',
                        'solicitud_id' => solicitud.id,
                        'agente_id'      => 1,                            #  TODO: Estos datos se deben de obtener
                        'agente_email'   => 'karen.valles@cimav.edu.mx')  #  del usuario que da de alta el servicio.

      render json: solicitud
    end

    def notificar_arranque
      solicitud = Solicitud.find(params[:id])

      # notificar a Bitacora
      ResqueBus.redis = '127.0.0.1:6379' # TODO: Mover a config
      ResqueBus.publish('notificar_arranque',
                        'solicitud_id' => solicitud.id,
                        'agente_id'      => 1,                            #  TODO: Estos datos se deben de obtener
                        'agente_email'   => 'karen.valles@cimav.edu.mx')  #  del usuario que da de alta el servicio.

      render json: solicitud
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
