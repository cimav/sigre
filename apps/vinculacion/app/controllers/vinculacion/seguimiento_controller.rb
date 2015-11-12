require_dependency "vinculacion/application_controller"

module Vinculacion
  class SeguimientoController < ApplicationController
    def index
      if @solicitud = Solicitud.find_by_vinculacion_hash(params[:hash])
        @cotizacion = @solicitud.ultima_cotizacion
      else
        render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found 
      end
    end
  end
end
