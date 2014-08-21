require_dependency "proyectos/application_controller"

module Proyectos
  class TiposController < ApplicationController

    def index
      results = Tipo.order(:id)
      render json: results
    end

    def show
      render json: Tipo.find(params[:id])
    end

  end
end

