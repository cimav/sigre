module Vinculacion
  class SolicitudBusquedaSerializer < ActiveModel::Serializer
    attributes :id
    attributes :codigo, :descripcion, :prioridad, :datos_usuario
    attributes :cliente_razon_social, :contacto_nombre, :proyecto_cuenta, :proyecto_nombre, :muestras_length, :servicios_length, :ultima_cotizacion, :tipo, :created_at
    attributes :status_text
  end
end