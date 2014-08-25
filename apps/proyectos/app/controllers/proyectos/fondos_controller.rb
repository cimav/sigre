require_dependency "proyectos/application_controller"

module Proyectos
  class FondosController < ApplicationController
    def index
      results = Fondo.order(:id)
      render json: results
    end

    def show
      render json: Fondo.find(params[:id])
    end
  end
end
