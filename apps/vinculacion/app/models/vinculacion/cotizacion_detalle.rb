module Vinculacion
  class CotizacionDetalle < ActiveRecord::Base
    belongs_to :cotizacion
  end
end
