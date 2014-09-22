require_dependency "proyectos/application_controller"

module Proyectos
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
      result = Proyecto.find(params[:id]).destroy == false ? false : true
      render :json => result, :status => :ok
    end

    protected
    def proyecto
      params[:proyecto].permit(
          :cuenta,
          :nombre,
          :descripcion,
          :impacto,
          :resultado_esperado,
          :objetivo_estrategico,
          :alcance,
          :referencia_externa,
          :convenio,
          :banco_cuenta,
          :anio,
          :fecha_inicio,
          :fecha_fin,
          :presupuesto_autorizado,
          :sede_id,
          :departamento_id,
          :tipo_id,
          :recurso_id,
          :fondo_id,
          :moneda_id,
          :responsable_id
      )
    end
  end
end
