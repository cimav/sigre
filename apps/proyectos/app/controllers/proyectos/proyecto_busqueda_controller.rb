require_dependency "proyectos/application_controller"

module Proyectos
  class ProyectoBusquedaController < ApplicationController
    def index
      results = ProyectoBusqueda.order(:id)
      if !params[:q].blank?
        results = results.where("(proyectos_proyectos.descripcion ILIKE :q OR
                                  proyectos_proyectos.nombre ILIKE :q OR
                                  proyectos_proyectos.cuenta ILIKE :q)",
                                {:q => "%#{params[:q]}%"})
      end
      render json: results
    end
  end
end
