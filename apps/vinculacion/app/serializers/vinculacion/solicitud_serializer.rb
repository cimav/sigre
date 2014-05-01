module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :usuario_id
    attributes :consecutivo, :codigo, :tipo, :prioridad, :contacto_email, :notas, :acuerdos, :status
    attributes :relation_string
    has_many :servicios
    has_many :muestras
    has_many :cotizaciones
    #has_one :proyecto
    has_one :sede
    has_one :cliente
    has_one :contacto
  end
end
