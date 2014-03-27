require_dependency "vinculacion/application_controller"

module Vinculacion
  class ProyectosController < ApplicationController
    def index
      results = Proyecto.order(:id)
      render json: results
    end

    def show
      render json: Proyecto.find(params[:id])
    end

    def create
      render json: Proyecto.create(proyecto)
    end

    def update
      render json: Proyecto.find(params[:id]).tap { |b| b.update_attributes(proyecto) }
    end

    def destroy
      render json: Proyecto.find(params[:id]).destroy
    end

    protected
    def proyecto
      params[:proyecto].permit(
                    :codigo,
                    :nombre,
                    :descripcion,
                    :obj_proyecto,
                    :impacto,
                    :resultado_esperado,
                    :obj_estrategico,
                    :anio,
                    :fecha_inicio,
                    :fecha_termino,
                    :status)
      end
  end
end
