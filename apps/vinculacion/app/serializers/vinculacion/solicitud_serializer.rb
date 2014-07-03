module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
    #include ActiveModel::Serializers::JSON
  	embed :ids, :include => true
    attributes :id
    attributes :usuario_id
    attributes :consecutivo, :codigo, :prioridad, :descripcion, :status, :motivo_status, :razon_cancelacion, :orden_compra, :fecha_inicio, :fecha_termino
    attributes :relation_string
    attributes :status_text

    has_many :servicios
    has_many :muestras
    has_many :cotizaciones
    has_one :proyecto
    has_one :sede
    has_one :cliente
    has_one :contacto

    # calculados
    attributes :costo_interno, :precio_venta

  end
end