require_dependency "vinculacion/application_controller"

module Vinculacion
  class CedulasController < ApplicationController
    def index
      results = Cedula.order(:codigo)
      render json: results
    end

    def show
      render json: Cedula.find(params[:id])
    end

    def create
      render json: Cedula.create(cedula_params)
    end

    def update
      render json: Cedula.find(params[:id]).tap { |b| b.update_attributes(cedula_params) }
    end

    def destroy
      render json: Cedula.find(params[:id]).destroy
    end

    protected
    def cedula_params
      params[:cedula].permit(:solicitud_id,
                               :servicio_id,
                               :codigo,
                               :status,
                               :cedula_netmultix,
                               :cliente_netmultix_id,
                               :concepto_en_extenso
                                )
    end
  end
end
