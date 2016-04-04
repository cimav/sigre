require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesNetmultixController < ApplicationController

    def index
      # render :inline => ver.id
      render json: ClienteNetmultix.order(:cl01_clave)
    end

    def show
      clave = "#{params[:id]}".strip
      cl = ClienteNetmultix.where("(cl01_clave = :q)", {:q => clave}).first
      puts cl.id
      render json: cl
    end

    protected
    def cliente
      params[:cliente_netmultix].permit(
          :cl01_clave,
          :cl01_nombre,
          :cl01_rfc
      )
    end

  end
end