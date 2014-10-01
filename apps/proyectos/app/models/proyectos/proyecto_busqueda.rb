module Proyectos
  class ProyectoBusqueda < ActiveRecord::Base
    self.table_name = "proyectos_proyectos"

    belongs_to  :departamento   # -> sede
    belongs_to  :recurso        # -> tipo
    belongs_to  :fondo          # -> recurso si es propio
    belongs_to  :moneda
    belongs_to  :responsable, class_name: "Empleado"

    def is_proyecto_base
      self.proyecto_base_id == nil
    end

    def cuenta_proyecto_base
      pb = Proyecto.where(["id = ?", self.proyecto_base_id]).select("id, cuenta").first
      pb.cuenta rescue 'BASE'
    end

    def sede_text
      self.departamento.sede.nombre + " " + self.departamento.sede.descripcion rescue 'Sin sede'
    end

    def departamento_text
      self.departamento.nombre + " " + self.departamento.descripcion rescue 'Sin departamento'
    end

    def tipo_text
      self.recurso.tipo.id.to_s + " " + self.recurso.tipo.nombre rescue 'Sin tipo'
    end

    def recurso_text
      self.recurso.id.to_s + " " + self.recurso.nombre rescue 'Sin tipo'
    end

    def fondo_text
      self.fondo.id.to_s + " " + self.fondo.nombre rescue 'Sin fondo'
    end

    def moneda_text
      self.moneda.codigo + " " + self.moneda.nombre rescue 'Sin moneda'
    end

    def responsable_text
      self.responsable.apellido_paterno.upcase + " " + self.responsable.apellido_materno.upcase + ", " + self.responsable.nombre rescue 'Sin responsable'
    end

  end
end
