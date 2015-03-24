require_dependency "vinculacion/application_controller"

module Vinculacion
  class SolicitudBusquedaController < ApplicationController
    def index
      results = SolicitudBusqueda.includes(:proyecto,:cliente, :usuario).order(:id)
      if !params[:q].blank?
        results = results.where("(vinculacion_solicitudes.descripcion LIKE :q OR
                                  vinculacion_solicitudes.codigo LIKE :q OR
                                  usuarios.usuario LIKE :q OR
                                  proyectos_proyectos.nombre LIKE :q OR
                                  vinculacion_clientes.razon_social LIKE :q)",
                                 {:q => "%#{params[:q]}%"})
      end
      render json: results
    end
  end
end
