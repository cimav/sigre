require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesNetmultixController < ApplicationController

    def index
      #clientes = ClienteNetmultix.where("(cl01_clave like '%36%')").order(:cl01_clave)
      clientes = ClienteNetmultix.order(:cl01_clave)

      clientes.each do |cliente|
        inject_id_to_conctactos cliente
      end

      render json: clientes
    end

    def show
      clave = "#{params[:id]}".strip.to_i
      cliente = ClienteNetmultix.where("(cl01_clave = :q)", {:q => clave}).first

      inject_id_to_conctactos cliente

      render json: cliente, serializer: ClienteNetmultixSerializer # se requiere especificar el serializer a usar
    end

    def inject_id_to_conctactos(cliente)
      i = 1
      cliente.contactos_netmultix.each do |contacto|
        contacto.id =  i
        i=i+1
      end
    end

  end
end