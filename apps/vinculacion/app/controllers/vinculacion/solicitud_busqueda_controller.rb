require_dependency "vinculacion/application_controller"

module Vinculacion
  class SolicitudBusquedaController < ApplicationController
    def index
      results = SolicitudBusqueda.includes(:proyecto,:cliente, :contacto).order(:id)
      if !params[:q].blank?
        results = results.where("(vinculacion_solicitudes.descripcion ILIKE :q OR 
                                  vinculacion_proyectos.nombre ILIKE :q OR
                                  vinculacion_clientes.razon_social ILIKE :q OR
                                  vinculacion_contactos.nombre ILIKE :q)",
                                 {:q => "%#{params[:q]}%"})
      end
      render json: results
    end
  end
end
