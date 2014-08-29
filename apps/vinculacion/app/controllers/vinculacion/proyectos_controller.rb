require_dependency "vinculacion/application_controller"

module Vinculacion
  class ProyectosController < ApplicationController

    def index
     # TODO .where(:tipo_id=>1) es hard code. Cambiarlo
      results = Proyecto.where(:tipo_id=>1).order(:id)
      render json: results
    end

    def show
      render json: Proyecto.find(params[:id])
    end

  end
end
