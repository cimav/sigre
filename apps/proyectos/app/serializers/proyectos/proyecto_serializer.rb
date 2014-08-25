module Proyectos
  class ProyectoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :cuenta, :nombre, :descripcion, :impacto, :resultado_esperado, :objetivo_estrategico, :alcance, :referencia_externa, :convenio, :banco_cuenta, :fecha_inicio, :fecha_fin, :anio, :presupuesto_autorizado

    has_one :fondo
    has_one :recurso
    has_one :tipo
    has_one :sede
    has_one :departamento
    has_one :moneda
    has_one :responsable, root: :empleado

  end
end






