module Proyectos
  class Sede < ActiveRecord::Base

    self.table_name = "rh_sedes"

    has_many :departamentos

  end
end