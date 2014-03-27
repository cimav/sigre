module Vinculacion
  class ServiciosMuestras < ActiveRecord::Base
  	self.table_name = "vinculacion_servicios_muestras"
    belongs_to :servicio
    belongs_to :muestra
  end
end
