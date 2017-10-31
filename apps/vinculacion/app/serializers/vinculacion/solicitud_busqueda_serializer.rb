module Vinculacion
  class SolicitudBusquedaSerializer < ActiveModel::Serializer
    attributes :id
    attributes :codigo, :descripcion, :prioridad, :tipo, :created_at, :orden_compra
    attributes :datos_usuario, :cliente_razon_social, :contacto_nombre, :proyecto_cuenta, :proyecto_nombre
    attributes :status_text
  end
end