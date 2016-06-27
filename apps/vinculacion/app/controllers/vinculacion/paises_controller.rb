require_dependency "vinculacion/application_controller"

module Vinculacion
  class PaisesController < ApplicationController
    def index
      render json: ::Pais.all
    end

    def show
      render json: ::Pais.find(params[:id])
    end

    protected
    def pais
      params[:pais].permit(:id,:nombre)
    end
  end
end
