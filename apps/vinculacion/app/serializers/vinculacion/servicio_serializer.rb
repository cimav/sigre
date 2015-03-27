module Vinculacion
  class ServicioSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :nombre, :descripcion, :empleado_id, :consecutivo, :codigo, :status
    attributes :status_text, :solicitud_id
    has_many :muestras
    has_many :costeos

    attributes  :servicio_bitacora_id

  end
end