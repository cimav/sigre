require_dependency "vinculacion/application_controller"

module Vinculacion
  class ContactosNetmultixController < ApplicationController

    def index
      render json: ContactoNetmultix.order(:cl06_clave), serializer: ContactoNetmultixSerializer
    end

    def show
      clave = "#{params[:id]}".strip.to_i
      result = ContactoNetmultix.where("(cl06_clave = :q)", {:q => clave})
      render json: result, serializer: ContactoNetmultixSerializer
    end

  end
end