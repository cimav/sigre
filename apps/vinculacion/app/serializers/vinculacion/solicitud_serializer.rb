module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :sede_id, :cliente_id, :contacto_id, :usuario_id #:proyecto_id
    attributes :consecutivo, :codigo, :tipo, :prioridad, :contacto_email, :notas, :acuerdos, :status
    has_many :servicios
    has_many :muestras
    has_one :proyecto
  end
end
