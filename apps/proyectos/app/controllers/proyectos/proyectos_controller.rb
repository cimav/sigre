require_dependency "proyectos/application_controller"

module Proyectos
  class ProyectosController < ApplicationController

    before_filter :auth_required

    def index

      results = Proyecto.order(:id)

      # filtrar por tipo de Usuario
      if current_user.interno?
        results = results.where(" tipo_id = 1 ")
      elsif current_user.externo?
        results = results.where(" tipo_id = 2 ")
      end

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
          :responsable_id,
          :proyecto_base_id
      )
    end
  end
end
