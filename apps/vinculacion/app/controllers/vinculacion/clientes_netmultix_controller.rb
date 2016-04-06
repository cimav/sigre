require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesNetmultixController < ApplicationController

    def index
      render json: ClienteNetmultix.order(:cl01_clave), serializer: ClienteNetmultixSerializer
    end

    def show
      clave = "#{params[:id]}".strip.to_i
      result = ClienteNetmultix.where("(cl01_clave = :q)", {:q => clave}).first
      render json: result, serializer: ClienteNetmultixSerializer # se requiere especificar el serializer a usar
    end

  end
end