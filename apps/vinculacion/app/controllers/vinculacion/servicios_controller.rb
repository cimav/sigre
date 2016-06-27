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

    def cancelar
      servicio = Servicio.find(params[:id])
      servicio.status = Servicio::CANCELADO

      # Notificar a Bitacora cuando es Servicio III
      if servicio.solicitud.tipo == 3 && servicio.status > Servicio::INICIAL
        puts "Cancelar servicio solicitado #{servicio.id}"
        QueueBus.publish('cancelar_servicio_solicitado',
                          'id'   => servicio.id,
                          'solicitud_id'  => servicio.solicitud_id,
                          'agente_id'      => servicio.solicitud.usuario.id,
                          'agente_email'   => servicio.solicitud.usuario.email)
      end

      servicio.save
      render json: servicio
    end

    def solicitar_costeo
      servicio = Servicio.find(params[:id])

      array_muestras = []
      servicio.muestras.each do |muestra|
          array_detalles = []
          muestra.muestra_detalle.each do |detalle|
              array_detalles << detalle
          end
          muestra_item = {
              'muestra'  => muestra,
              'detalles' => array_detalles
          }
          array_muestras << muestra_item
      end

        cliente_id = servicio.solicitud.cliente_id
        cliente_razon_social = servicio.solicitud.cliente.razon_social
        cliente_contacto = servicio.solicitud.contacto.nombre   rescue '-'
        cliente_email    = servicio.solicitud.contacto.email    rescue '-'
        cliente_telefono = servicio.solicitud.contacto.telefono rescue '-'
        cliente_calle    = servicio.solicitud.cliente.calle_num rescue '--'
        cliente_colonia  = servicio.solicitud.cliente.colonia   rescue '--'
        cliente_ciudad   = servicio.solicitud.cliente.ciudad    rescue '--'
        cliente_estado   = servicio.solicitud.cliente.estado.nombre rescue '--'
        cliente_pais     = servicio.solicitud.cliente.pais.nombre   rescue '--'
        cliente_cp       = servicio.solicitud.cliente.cp            rescue '--'

      QueueBus.publish('solicitar_costeo',  'id'               => servicio.id,
                                            'solicitud_id'     => servicio.solicitud_id,
                                            'codigo'           => servicio.codigo,
                                            'nombre'           => servicio.nombre,
                                            'empleado_id'      => servicio.empleado_id,
                                            'empleado_email'   => servicio.empleado.email,
                                            'agente_id'        => servicio.solicitud.usuario.id,
                                            'agente_email'     => servicio.solicitud.usuario.email,
                                            'cliente_id'       => cliente_id,
                                            'cliente_nombre'   => cliente_razon_social,
                                            'cliente_contacto' => cliente_contacto,
                                            'cliente_email'    => cliente_email,
                                            'cliente_telefono' => cliente_telefono,
                                            'cliente_calle'    => cliente_calle,
                                            'cliente_colonia'  => cliente_colonia,
                                            'cliente_ciudad'   => cliente_ciudad,
                                            'cliente_estado'   => cliente_estado,
                                            'cliente_pais'     => cliente_pais,
                                            'cliente_cp'       => cliente_cp,
                                            'descripcion'      => servicio.descripcion,
                                            'vinculacion_hash' => servicio.solicitud.vinculacion_hash,
                                            'muestras'         => array_muestras
      )

      servicio.status = Servicio::ESPERANDO_COSTEO
      servicio.save
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
                                :empleado_id,
                                :status,
                                :servicio_bitacora_id
      )
    end
  end
end
