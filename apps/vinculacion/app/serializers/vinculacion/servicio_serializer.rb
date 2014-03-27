module Vinculacion
  class ServicioSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :nombre, :descripcion, :empleado_id, :consecutivo, :codigo, :status
    attributes :status_text
    has_many :muestras
  end
end