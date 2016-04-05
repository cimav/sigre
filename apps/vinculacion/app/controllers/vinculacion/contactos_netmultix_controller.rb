require_dependency "vinculacion/application_controller"

module Vinculacion
  class ContactosNetmultixController < ApplicationController

    def index
      render json: ClienteNetmultix.order(:cl01_clave)
    end

  end
end