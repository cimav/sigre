require_dependency "vinculacion/application_controller"

module Vinculacion
  class CotizacionesController < ApplicationController
    def index
      results = Cotizacion.where(:solicitud_id => params[:solicitud_id])
      render json: results
    end

    def show
      render json: Cotizacion.find(params[:id])
    end

    def create

      @cotiza = cotizacion
      letra = @cotiza[:consecutivo]
      if letra.nil?
        # es la 1era cotizacion, valores por default
         letra = 'A'
         @cotiza[:condicion] = 0
         @cotiza[:idioma] = 0
         @cotiza[:divisa] = 0
         @cotiza[:comentarios] = 'Los comentarios default de la cotización'
         @cotiza[:observaciones] = 'Las observaciones default'
         @cotiza[:notas] = 'La o las notas por omisión'
         @cotiza[:subtotal] = 0.00
         @cotiza[:precio_venta] = 0.00
         @cotiza[:precio_unitario] = 0.00
         @cotiza[:descuento_porcentaje] = 0.00
         @cotiza[:descuento_status] = 0
      else
        # clonar la cotizacion anterior y agrega el consecutivo
         letra = letra.next
       end
      @cotiza[:consecutivo] = letra
      @cotiza[:status] = 1 #edicion #ember.CotizacionController.Status

      @cotiza = Cotizacion.create(@cotiza)

      render json: @cotiza
    end

    def update
      render json: Cotizacion.find(params[:id]).tap { |b| b.update_attributes(cotizacion) }
    end

    def destroy
      render json: Cotizacion.find(params[:id]).destroy
    end

    protected
    def cotizacion
      params[:cotizacion].permit(
          :id,
          :solicitud_id,
          :consecutivo,
          :fecha_notificacion,
          :condicion,
          :idioma,
          :divisa,
          :comentarios,
          :observaciones,
          :notas,
          :subtotal,
          :precio_venta,
          :precio_unitario,
          :descuento_porcentaje,
          :descuento_status,
          :status)
    end
  end
end

