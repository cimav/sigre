module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
    attributes :proyecto_id, :sede_id, :cliente_id, :contacto_id, :usuario_id
    attributes :id, :consecutivo, :codigo, :tipo, :prioridad, :contacto_email, :notas, :acuerdos, :status
    has_many :muestras
  end
end
