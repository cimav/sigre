require_dependency "vinculacion/application_controller"

module Vinculacion
  class UsuariosController < ApplicationController
    def index
      render json: ::Usuario.all
    end

    def show
      render json: ::Usuario.find(params[:id])
    end

    def auth_outside
      render text: !::Usuario.where(:email => params[:user_email]).first.nil?
    end
  end
end