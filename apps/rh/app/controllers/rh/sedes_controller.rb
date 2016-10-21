require_dependency "rh/application_controller"

module Rh
  class SedesController < ApplicationController
  	def index
      render json: Sede.all
    end

    def show
      render json: Sede.find(params[:id])
    end

    def create
      render json: Sede.create(sede)
    end

    def update
      render json: Sede.find(params[:id]).tap { |b| b.update_attributes(sede) }
    end

    def destroy
      render json: Sede.find(params[:id]).destroy
    end

    protected
    def sede
      params[:sede].permit(:id,
      	                   :nombre,
      	                   :descripcion,
      	                   :empleado_id)
    end
  end
end
