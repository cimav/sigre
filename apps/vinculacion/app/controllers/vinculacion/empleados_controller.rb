require_dependency "vinculacion/application_controller"

module Vinculacion
  class EmpleadosController < ApplicationController
    def index
      render json: Empleado.all
    end

    def show
      render json: Empleado.find(params[:id])
    end
  end
end
