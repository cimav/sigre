module Proyectos
  class Departamento < ActiveRecord::Base

    self.table_name = "rh_departamentos"

    has_many :empleado
  end
end