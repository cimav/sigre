require_dependency "vinculacion/application_controller"

module Vinculacion
  class ContactosController < ApplicationController
    def index
      results = Contacto.order(:cliente_id)
      if !params[:cliente_id].blank?
        results = results.where(:cliente_id => params[:cliente_id])
      end
      render json: results
    end

    def show
      render json: Contacto.find(params[:id])
    end

    def create
      render json: Contacto.create(contacto)
    end

    def update
      render json: Contacto.find(params[:id]).tap { |b| b.update_attributes(contacto) }
    end

    def destroy
      render json: Contacto.find(params[:id]).destroy
    end

    protected
    def contacto
      params[:contacto].permit(:cliente_id,
                              :nombre,
                              :telefono,
                              :email)
    end
  end
end
