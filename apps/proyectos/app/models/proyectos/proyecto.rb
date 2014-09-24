module Proyectos
  class Proyecto < ActiveRecord::Base

    belongs_to  :sede
    belongs_to  :departamento
    belongs_to  :tipo
    belongs_to  :recurso
    belongs_to  :fondo
    belongs_to  :moneda
    belongs_to  :responsable, class_name: "Empleado"

    has_many    :sub_proyectos, class_name: "Proyecto", foreign_key: "proyecto_base_id"
    belongs_to  :proyecto_base, class_name: "Proyecto"

    def is_sub_proyecto_of?(proyecto_id)
      proyecto_base_id == proyecto_id
    end

    def is_proyecto_base_of?(proyecto_id)
      sub_proyectos_ids.includes? proyecto_id
    end

  end
end
