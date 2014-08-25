require_dependency "proyecto/application_controller"

module Proyectos
  class DepartamentosController < ApplicationController
    def index
      render json: Departamento.all
    end

    def show
      render json: Departamento.find(params[:id])
    end

  end
end
