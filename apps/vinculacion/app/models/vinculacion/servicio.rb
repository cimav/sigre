module Vinculacion
  class Servicio < ActiveRecord::Base
  	belongs_to :solicitud
  	has_and_belongs_to_many :muestras, :join_table => :vinculacion_servicios_muestras
  end
end
