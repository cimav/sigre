require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesNetmultixController < ApplicationController

    def index

#      clientes = ClienteNetmultix.order(:cl01_clave)

      clientes  = ClienteNetmultix
                      .joins("JOIN cl12 ON cl12.cl12_pais = cl01.cl01_pais")
                      .joins("JOIN cl19 ON cl19.cl19_estado = cl01.cl01_estado")
                      .joins("JOIN cl13 ON cl13.cl13_ciudad = cl01.cl01_ciudad")
                      .select("cl01.*, cl12.cl12_nombre as pais, cl19.cl19_nombre as estado, cl13.cl13_nombre as ciudad")
                      .order(:cl01_clave)

      clientes.each do |cliente|
        inject_id_to_contactos cliente
      end

      render json: clientes
    end

    def show
      clave = "#{params[:id]}".strip.to_i
#      cliente = ClienteNetmultix.where("(cl01_clave = :q)", {:q => clave}).first

      cliente = ClienteNetmultix
                    .joins("JOIN cl12 ON cl12.cl12_pais = cl01.cl01_pais")
                    .joins("JOIN cl19 ON cl19.cl19_estado = cl01.cl01_estado")
                    .joins("JOIN cl13 ON cl13.cl13_ciudad = cl01.cl01_ciudad")
                    .where("(cl01_clave = :q)", {:q => clave})
                    .select("cl01.*, cl12.cl12_nombre as pais, cl19.cl19_nombre as estado, cl13.cl13_nombre as ciudad").first


      inject_id_to_contactos cliente

      render json: cliente, serializer: ClienteNetmultixSerializer # se requiere especificar el serializer a usar
    end

    def inject_id_to_contactos(cliente)
      i = 1
      cliente.contactos_netmultix.each do |contacto|
        contacto.id =  i
        i=i+1
      end
    end

  end
end