require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesController < ApplicationController
    def index
      results = Cliente.order(:razon_social)
      render json: results
    end

    def show
      render json: Cliente.find(params[:id])
    end

    def create
      render json: Cliente.create(cliente)
    end

    def update
      render json: Cliente.find(params[:id]).tap { |b| b.update_attributes(cliente) }
    end

    def destroy
      render json: Cliente.find(params[:id]).destroy
    end

    protected
    def cliente
      params[:cliente].permit(:rfc,
                              :razon_social)
    end
  end
end