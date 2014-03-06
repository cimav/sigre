require_dependency "rh/application_controller"

module Rh
  class EmpleadosController < ApplicationController
  	def index
      render json: Empleado.all
    end

    def show
      render json: Empleado.find(params[:id])
    end

    def create
      render json: Empleado.create(empleado)
    end

    def update
      render json: Empleado.find(params[:id]).tap { |b| b.update_attributes(empleado) }
    end

    def destroy
      render json: Empleado.find(params[:id]).destroy
    end

    protected
    def empleado
      params[:empleado].permit(:nombre,
                               :apellido_paterno,
                               :apellido_materno,
                               :email,
                               :puesto,
                               :sede_id,
                               :fecha_nacimiento,
                               :pais_id,
                               :fecha_inicio,
                               :fecha_fin,
                               :curp,
                               :rfc,
                               :departamento_id,
                               :empleado_id,
                               :image)
    end
  end
end

