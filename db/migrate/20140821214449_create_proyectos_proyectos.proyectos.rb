# This migration comes from proyectos (originally 20140821211249)
class CreateProyectosProyectos < ActiveRecord::Migration
  def change
    create_table :proyectos_proyectos do |t|
      t.string  :cuenta
      t.string  :nombre
      t.text    :descripcion
      t.text    :impacto
      t.text    :resultado_esperado
      t.text    :objetivo_estrategico
      t.text    :alcance
      t.string  :referencia_externa
      t.string  :convenio
      t.string  :banco_cuenta
      t.date    :fecha_inicio
      t.date    :fecha_fin
      t.integer :anio, :default => 0
      t.decimal :presupuesto_autorizado, :precision => 10, :scale => 2, :default => 0.00

      t.references  :fondo
      t.references  :recurso
      t.references  :tipo
      t.references  :departamento
      t.references  :sede
      t.references  :moneda

      t.timestamps
    end
  end
end
