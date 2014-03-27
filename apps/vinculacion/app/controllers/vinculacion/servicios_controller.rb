require_dependency "vinculacion/application_controller"
require 'resque-bus'

module Vinculacion
  class ServiciosController < ApplicationController
  	def index
      results = Servicio.order(:consecutivo)
      render json: results
    end

    def show
      render json: Servicio.find(params[:id])
    end

    def solicitar_costeo
      servicio = Servicio.find(params[:id])
      ResqueBus.redis = '127.0.0.1:6379' # TODO: Mover a config
      ResqueBus.publish('solicitar_costeo', 'id'          => servicio.id, 
                                            'nombre'      => servicio.nombre,
                                            'empleado_id' => servicio.empleado_id,
                                            'descripcion' => servicio.descripcion,
                                            'muestras'    => servicio.muestras)
      servicio.status = 2 # STATUS DE COSTEO, TODO: Crear constantes
      servicio.save
      puts "SOLICITAR COSTEO"
      render json: servicio
    end

    def create
      servicio = Servicio.create(servicio_params)

      # Hack para guardar en servicios_muestras
      if params[:servicio][:muestras_string]
        params[:servicio][:muestras_string].split(",").map(&:to_i).each do |m|
          ServiciosMuestras.create(:servicio_id => servicio.id, :muestra_id => m)
        end
      end

      render json: servicio
    end

    def update
      
      # Hack para guardar en servicios_muestras
      if params[:servicio][:muestras_string]
        ServiciosMuestras.delete_all(:servicio_id => params[:id])
        params[:servicio][:muestras_string].split(",").map(&:to_i).each do |m|
          ServiciosMuestras.create(:servicio_id => params[:id], :muestra_id => m)
        end
      end

      render json: Servicio.find(params[:id]).tap { |b| b.update_attributes(servicio_params) }
    end

    def destroy
      render json: Servicio.find(params[:id]).destroy
    end

    protected
    def servicio_params
      params[:servicio].permit(:solicitud_id,
                                :nombre,
                                :descripcion,
                                :empleado_id)
    end
  end
end
