module Proyectos
  class Departamento < ActiveRecord::Base

    self.table_name = "rh_departamentos"

    belongs_to :sede
    has_many :empleado
  end
end