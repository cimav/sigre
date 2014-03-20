require_dependency "vinculacion/application_controller"

module Vinculacion
  class MuestrasController < ApplicationController
  	def index
      render json: Muestra.where(:solicitud_id => params[:solicitud_id])
    end

    def show
      render json: Muestra.find(params[:id])
    end

    def create
      render json: Muestra.create(muestra)
    end

    def update
      render json: Muestra.find(params[:id]).tap { |b| b.update_attributes(muestra) }
    end

    def destroy
      render json: Muestra.find(params[:id]).destroy
    end

    protected
    def muestra
      params[:muestra].permit(:solicitud_id,
                              :consecutivo,
                              :codigo,
                              :identificacion,
                              :descripcion,
                              :cantidad,
                              :usuario_id,
                              :status)
    end
  end
end
