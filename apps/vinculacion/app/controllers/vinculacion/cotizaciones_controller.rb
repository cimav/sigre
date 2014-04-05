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

      letra = Cotizacion.where(:solicitud_id => params[:solicitud_id]).maximum('consecutivo')
      if letra.nil?
        letra = 'A'
      else
        letra = letra.next
      end

      @cotiza = Cotizacion.new(cotizacion)
      @cotiza.consecutivo = letra
      @cotiza.save

      render json: @cotiza
#      render json: Cotizacion.create(cotizacion)
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

