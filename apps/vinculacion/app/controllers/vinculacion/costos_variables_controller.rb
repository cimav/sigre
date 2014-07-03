require_dependency "vinculacion/application_controller"

module Vinculacion
  class CostosVariablesController < ApplicationController
    def index
      render json: CostoVariable.where(:cedula_id => params[:cedula_id])
    end

    def show
      render json: CostoVariable.find(params[:id])
    end

    def create
      render json: CostoVariable.create(costo_variable)
    end

    def update
      render json: CostoVariable.find(params[:id]).tap { |b| b.update_attributes(costo_variable) }
    end

    def destroy
      render json: CostoVariable.find(params[:id]).destroy
    end

    protected
    def costo_variable
      params[:costo_variable].permit(:cedula_id,
                               :tipo,
                               :descripcion,
                               :costo)
    end
  end
end

