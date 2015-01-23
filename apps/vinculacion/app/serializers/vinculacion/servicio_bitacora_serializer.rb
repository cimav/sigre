module Vinculacion
  class ServicioBitacoraSerializer < ActiveModel::Serializer
    #embed :ids, :include => true
    attributes :id
    attributes :bitacora_id
    attributes :nombre, :descripcion, :precio_venta, :costo_interno, :status

    attributes :empleado_id

  end
end
