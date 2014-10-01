require_dependency "proyectos/application_controller"

module Proyectos
  class MonedasController < ApplicationController
    def index
      render json: Moneda.all
    end

    def show
      render json: Moneda.find(params[:id])
    end

  end
end
