require_dependency "proyectos/application_controller"

module Proyectos
  class RecursosController < ApplicationController

    def index
      results = Recurso.order(:id)
      render json: results
    end

    def show
      render json: Recurso.find(params[:id])
    end

  end
end
