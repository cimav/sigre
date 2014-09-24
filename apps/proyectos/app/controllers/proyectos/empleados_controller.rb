require_dependency "proyectos/application_controller"

module Proyecto
  class EmpleadosController < ApplicationController
    def index
      render json: Empleado.all
    end

    def show
      render json: Empleado.find(params[:id])
    end
  end
end
