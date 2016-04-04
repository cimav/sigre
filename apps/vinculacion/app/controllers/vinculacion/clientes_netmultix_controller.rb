require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesNetmultixController < ApplicationController

    def index
      render json: ClienteNetmultix.order(:cl01_clave)
    end

    def show
      clave = "#{params[:id]}".strip
      render json: ClienteNetmultix.where("(cl01_clave = :q)", {:q => clave})
    end

  end
end