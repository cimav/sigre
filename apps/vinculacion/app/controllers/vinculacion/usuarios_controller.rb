require_dependency "vinculacion/application_controller"

module Vinculacion
  class UsuariosController < ApplicationController
    def index
      render json: ::Usuario.all
    end

    def show
      render json: ::Usuario.find(params[:id])
    end
  end
end
