module Vinculacion
  class SolicitudBusquedaSerializer < ActiveModel::Serializer
    attributes :id
    attributes :codigo, :descripcion, :prioridad
    attributes :cliente_razon_social, :contacto_nombre, :proyecto_codigo, :proyecto_nombre
  end
end