require_dependency "proyecto/application_controller"

module Proyectos
  class SedesController < ApplicationController
    def index
      render json: Sede.all
    end

    def show
      render json: Sede.find(params[:id])
    end

    protected
    def sede
      params[:sede].permit(
          :id,
          :nombre,
          :descripcion
      )
    end
  end
end
