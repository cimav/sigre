require_dependency "proyectos/application_controller"

module Proyectos
  class MonedasController < ApplicationController
    def index
      render json: Sede.all
    end

    def show
      render json: Sede.find(params[:id])
    end

  end
end
