require_dependency "vinculacion/application_controller"

module Vinculacion
  class CosteosController < ApplicationController
    def show
      render json: Costeo.find(params[:id])
    end
  end
end