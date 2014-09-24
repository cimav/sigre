module Proyectos
  class ProyectoSerializer < ActiveModel::Serializer
    embed :ids, :include => true
    attributes :id
    attributes :cuenta, :nombre, :descripcion, :impacto, :resultado_esperado, :objetivo_estrategico, :alcance, :referencia_externa, :convenio, :banco_cuenta, :fecha_inicio, :fecha_fin, :anio, :presupuesto_autorizado

    attributes :tipo_id, :recurso_id, :fondo_id, :departamento_id, :sede_id

    # has_one :tipo
    # has_one :recurso
    # has_one :fondo
    # has_one :sede
    # has_one :departamento
    # has_one :moneda
    has_one :responsable, root: :empleado

    #has_one :proyecto_base, root: :proyecto
    attributes :proyecto_base_id

    attributes :values_belongs_to # usada para forzar el isDirty en las belongsTo
    def values_belongs_to
      emp_resp = responsable.id rescue 'null'
      "#{sede_id},#{departamento_id},#{emp_resp},#{tipo_id},#{recurso_id},#{fondo_id}"
    end

  end
end






