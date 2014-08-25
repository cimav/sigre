module Proyectos
  class Proyecto < ActiveRecord::Base

    belongs_to  :sede
    belongs_to  :departamento
    belongs_to  :tipo
    belongs_to  :recurso
    belongs_to  :fondo
    belongs_to  :moneda
    belongs_to  :responsable, class_name: "Empleado"


  end
end
