module Vinculacion
  class ProyectoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :codigo, :nombre, :descripcion, :obj_proyecto, :impacto, :resultado_esperado, :obj_estrategico, :anio, :fecha_inicio, :fecha_termino, :status
    #has_many  :solicitudes
  end
end
