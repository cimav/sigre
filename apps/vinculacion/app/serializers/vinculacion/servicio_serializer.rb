module Vinculacion
  class ServicioSerializer < ActiveModel::Serializer
  	embed :ids, :include => true
    attributes :id
    attributes :nombre, :descripcion, :empleado_id, :consecutivo, :codigo, :status
    attributes :status_text
    has_many :muestras
    has_many :costeos
    has_many :costo_variable
    has_many :remanentes

    #calculados
    attributes :total_costo_variable, :costo_indirecto, :costo_interno, :porcentaje_participacion, :utilidad, :precio_venta, :remanente_distribuible

  end
end