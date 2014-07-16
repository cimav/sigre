module Vinculacion
  class CedulaSerializer < ActiveModel::Serializer
    embed :ids, :include => true

    attributes :id
    attributes :codigo, :status
    has_many :costo_variable
    has_many :remanentes

    attributes :solicitud_id
    attributes :servicio_id
    #has_one :solicitud

    #calculados
    attributes :total_costo_variable, :costo_indirecto, :costo_interno, :porcentaje_participacion, :precio_venta, :utilidad_neta, :utilidad_topada, :remanente_distribuible

  end
end