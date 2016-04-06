require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesNetmultixController < ApplicationController

    def index
      render json: ClienteNetmultix.order(:cl01_clave)#, serializer: ClienteNetmultixSerializer
    end

    def show
      clave = "#{params[:id]}".strip.to_i
      result = ClienteNetmultix.where("(cl01_clave = :q)", {:q => clave}).first

      i = 1
      result.contactos_netmultix.each do |contacto|
        contacto.id =  i
        i=i+1
        puts contacto.id
      end

      result.contactos_netmultix.each do |contacto|
        #puts contacto.id
      end

      render json: result, serializer: ClienteNetmultixSerializer # se requiere especificar el serializer a usar
    end

  end
end