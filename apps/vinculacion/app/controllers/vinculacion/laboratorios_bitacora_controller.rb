# coding: utf-8
require_dependency "vinculacion/application_controller"

module Vinculacion
  class LaboratoriosBitacoraController < ApplicationController

    def index
      render json: LaboratorioBitacora.all
    end

    def show
      render json: LaboratorioBitacora.find(params[:id])
    end


  end
end
