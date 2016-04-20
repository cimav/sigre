module Vinculacion
  class SolicitudSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :consecutivo, :codigo, :prioridad, :descripcion, :status, :motivo_status, :razon_cancelacion, :orden_compra, :fecha_inicio, :fecha_termino
    attributes :tipo, :duracion, :tiempo_entrega, :created_at, :vinculacion_hash
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
    attributes :proyecto_id, :sede_id, :cliente_id, :contacto_id, :usuario_id

    attributes :cliente_netmultix_id, :contacto_netmultix_id, :contacto_netmultix_email, :contacto_netmultix_nombre, :pais_netmultix_nombre, :estado_netmultix_nombre, :ciudad_netmultix_nombre

    has_many :cedulas

    has_many :alertas
    has_many :registros

    # calculados
    attributes :costo_interno, :precio_venta

    #has_one :responsable_presupuestal , class_name: "empleado"
    #attributes :responsable_presupuestal_id

    has_one :responsable_presupuestal, root: :empleado

    def alertas
      #object.registros.where(solicitud_id: object.id,tipo: Registro::TIPO_ALERTA)
      object.registros
    end





  end
end