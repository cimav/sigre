module Vinculacion
  class Cotizacion < ActiveRecord::Base
    belongs_to :solicitud
    has_many :cotizaciones_detalle
  end
end
