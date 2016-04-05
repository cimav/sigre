require_dependency "vinculacion/application_controller"

module Vinculacion
  class ClientesNetmultixController < ApplicationController

    def index
      render json: ClienteNetmultix.order(:cl01_clave)
    end

    def show

      # render json: ClienteNetmultix.find(params[:id])

      clave = "#{params[:id]}".strip.to_i
      puts clave
      render json: ClienteNetmultix.where("(cl01_clave = :q)", {:q => clave}).first
    end

  end
end