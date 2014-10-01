module Proyectos
  class ProyectoBusquedaSerializer < ActiveModel::Serializer
    attributes :id
    attributes :cuenta, :nombre, :descripcion, :fecha_inicio, :fecha_fin, :anio
    attributes :sede_text, :departamento_text, :tipo_text, :recurso_text, :fondo_text, :moneda_text, :responsable_text

    attributes :is_proyecto_base, :cuenta_proyecto_base
  end
end
