# coding: utf-8
require_dependency "vinculacion/application_controller"

module Vinculacion
  class ServiciosBitacoraController < ApplicationController

    def index
      render json: ServicioBitacora.all
    end

    def show
      render json: ServicioBitacora.find(params[:id])
    end


  end
end
