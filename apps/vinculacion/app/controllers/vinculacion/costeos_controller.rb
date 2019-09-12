require_dependency "vinculacion/application_controller"

module Vinculacion
  class CosteosController < ApplicationController
    def show
      render json: Costeo.find(params[:id])
    end

    def update
      render json: Costeo.find(params[:id]).tap { |b| b.update_attributes(costeo_params) }
    end

    protected
    def costeo_params
      params[:costeo].permit(
          :mostrar_leyenda
      )
    end

  end
end