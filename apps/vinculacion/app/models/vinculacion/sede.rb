module Vinculacion
  class Sede < ActiveRecord::Base

    self.table_name = "rh_sedes"

    #belongs_to :solicitud

  end
end