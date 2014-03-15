module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :proyecto_id, :sede_id, :cliente_id, :contacto_id, :usuario_id
    attributes :consecutivo, :codigo, :tipo, :prioridad, :contacto_email, :notas, :acuerdos, :status
    has_many :muestras
  end
end
