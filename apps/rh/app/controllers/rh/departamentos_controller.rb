require_dependency "rh/application_controller"

module Rh
  class DepartamentosController < ApplicationController
  	def index
      render json: Departamento.all
    end

    def show
      render json: Departamento.find(params[:id])
    end

    def create
      render json: Departamento.create(departamento)
    end

    def update
      render json: Departamento.find(params[:id]).tap { |b| b.update_attributes(departamento) }
    end

    def destroy
      render json: Departamento.find(params[:id]).destroy
    end

    protected
    def departamento
      params[:departamento].permit(:id, 
      	                           :nombre, 
      	                           :descripcion, 
      	                           :sede_id, 
      	                           :empleado_id, 
      	                           :departamento_id)
    end
  end
end
