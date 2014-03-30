module Vinculacion
  class CosteoSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :nombre_servicio, :muestra_id, :servicio_id, :codigo, :status
    has_many :costeo_detalle
  end
end