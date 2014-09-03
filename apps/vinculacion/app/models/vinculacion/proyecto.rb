module Vinculacion
  class Proyecto < ActiveRecord::Base

    self.table_name = "proyectos_proyectos"

    has_many :solicitudes

    before_destroy :check_for_solicitudes

    private

    def check_for_solicitudes
      if solicitudes.count > 0
        errors.add(:base, "No puede borrar el Proyecto mientras contenga " + solicitudes.count.to_s + " Solicitud(es)")
        return false
      end
    end

  end
end
