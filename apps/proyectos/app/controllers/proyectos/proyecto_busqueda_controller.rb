require_dependency "proyectos/application_controller"

module Proyectos
  class ProyectoBusquedaController < ApplicationController

    before_filter :auth_required

    def index
      results = ProyectoBusqueda.order(:id)

      # filtrar por tipo de Usuario
      if current_user.interno?
        results = results.where(" tipo_id = 1 ")
      elsif current_user.externo?
        results = results.where(" tipo_id = 2 ")
      end

      if !params[:q].blank?
        results = results.where("(proyectos_proyectos.descripcion LIKE :q OR
                                  proyectos_proyectos.nombre LIKE :q OR
                                  proyectos_proyectos.cuenta LIKE :q)",
                                {:q => "%#{params[:q]}%"})
      end
      render json: results
    end

  end
end
