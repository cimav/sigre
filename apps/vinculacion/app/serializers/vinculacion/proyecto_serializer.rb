module Vinculacion
  class ProyectoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :codigo, :descripcion, :obj_proyecto, :impacto, :resultado_esperado, :obj_estrategico, :duracion_meses, :anio, :status
    #has_many :solicitudes
  end
end
