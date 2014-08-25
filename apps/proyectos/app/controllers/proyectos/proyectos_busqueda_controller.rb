require_dependency "proyectos/application_controller"

module Proyectos
  class ProyectosBusquedaController < ApplicationController
    def index
      results = ProyectoBusqueda.order(:id)
      render json: results
    end
  end
end
