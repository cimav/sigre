module Vinculacion
  class ServicioSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :nombre, :descripcion, :empleado_id, :status
    has_many :muestras
  end
end