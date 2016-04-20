require_dependency "vinculacion/application_controller"

module Vinculacion
  class RegistrosController < ApplicationController
    def index
      results = Registro.order(:solicitud_id)
      if !params[:solicitud_id].blank?
        results = results.where(:solicitud_id => params[:solicitud_id])
      end
      render json: results
    end

    def show
      render json: Registro.find(params[:id])
    end

    def create
      render json: Registro.create(registro)
    end

    def update
      render json: Registro.find(params[:id]).tap { |b| b.update_attributes(registro) }
    end

    def destroy
      render json: Registro.find(params[:id]).destroy
    end

    protected
    def registro
      params[:registro].permit(:solicitud_id,
                              :empleado_id,
                              :tipo,
                              :mensaje, 
                              :status)
    end
  end
end
