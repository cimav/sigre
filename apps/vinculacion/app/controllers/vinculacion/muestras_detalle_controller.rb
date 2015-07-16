require_dependency "vinculacion/application_controller"

module Vinculacion
  class MuestrasDetalleController < ApplicationController

    def index
      results = MuestraDetalle.where(:muestra_id => params[:muestra_id])
      render json: results
    end

    def show
      render json: MuestraDetalle.find(params[:id])
    end

    def create
      render json: MuestraDetalle.create(muestra_detalle)
    end

    def update
      render json: MuestraDetalle.find(params[:id]).tap { |b| b.update_attributes(muestra_detalle) }
    end

    def destroy
      render json: MuestraDetalle.find(params[:id]).destroy
    end

    protected
    def muestra_detalle
      params[:muestra_detalle].permit(
          :muestra_id,
          :consecutivo,
          :cliente_identificacion,
          :notas,
          :status
      )
    end
  end
end
