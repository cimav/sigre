require_dependency "vinculacion/application_controller"

module Vinculacion
  class RemanentesController < ApplicationController
    def index
      render json: Remanente.where(:cedula_id => params[:cedula_id])
    end

    def show
      render json: Remanente.find(params[:id])
    end

    def create
      render json: Remanente.create(remanente)
    end

    def update
      render json: Remanente.find(params[:id]).tap { |b| b.update_attributes(remanente) }
    end

    def destroy
      render json: Remanente.find(params[:id]).destroy
    end

    protected
    def remanente
      params[:remanente].permit(:cedula_id,
                                    :empleado_id,
                                    :porcentaje_participacion,
                                    :monto)
    end
  end
end

