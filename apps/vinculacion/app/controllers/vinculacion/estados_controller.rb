require_dependency "vinculacion/application_controller"

module Vinculacion
  class EstadosController < ApplicationController
    def index
      render json: ::Estado.all
    end

    def show
      render json: ::Estado.find(params[:id])
    end
    
    protected
    def pais
      params[:estado].permit(:id,:nombre)
    end
  end
end
