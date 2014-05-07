module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :usuario_id
    attributes :consecutivo, :codigo, :tipo, :prioridad, :descripcion, :status, :motivo_status, :razon_cancelacion
    attributes :relation_string
    has_many :servicios
    has_many :muestras
    has_many :cotizaciones
    has_one :proyecto
    has_one :sede
    has_one :cliente
    has_one :contacto
  end
end