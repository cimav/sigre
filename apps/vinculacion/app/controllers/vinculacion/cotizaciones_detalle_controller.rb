require_dependency "vinculacion/application_controller"

module Vinculacion
  class CotizacionesDetalleController < ApplicationController
    def index
      results = CotizacionDetalle.where(:cotizacion_id => params[:cotizacion_id])
      render json: results
    end

    def show
      render json: CotizacionDetalle.find(params[:id])
    end

    def create
      render json: CotizacionDetalle.create(cotizacion_detalle)
    end

    def update
      render json: CotizacionDetalle.find(params[:id]).tap { |b| b.update_attributes(cotizacion_detalle) }
    end

    def destroy
      render json: CotizacionDetalle.find(params[:id]).destroy
    end

    protected
    def cotizacion_detalle
      params[:cotizacion_detalle].permit(
          :cotizacion_id,
          :cantidad,
          :concepto,
          :precio_unitario,
          :status,
          :inmutable,
          :servicio_id
      )
    end
  end
end

