module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :usuario_id
    attributes :consecutivo, :codigo, :prioridad, :descripcion, :status, :motivo_status, :razon_cancelacion, :orden_compra, :fecha_inicio, :fecha_termino, :is_coordinado
    attributes :relation_string
    attributes :status_text

    has_many :servicios
    has_many :muestras
    has_many :cotizaciones

    # FixMe varificar has_one provocan stack level too deep
    # has_one :proyecto
    # has_one :sede
    # has_one :cliente
    # has_one :contacto
    attributes :proyecto_id, :sede_id, :cliente_id, :contacto_id

    has_many :cedulas

    # calculados
    attributes :costo_interno, :precio_venta

    #has_one :responsable_presupuestal , class_name: "empleado"
    #attributes :responsable_presupuestal_id

    has_one :responsable_presupuestal, root: :empleado

  end
end