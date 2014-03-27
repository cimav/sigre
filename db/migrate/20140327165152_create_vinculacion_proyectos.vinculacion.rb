# This migration comes from vinculacion (originally 20140327164007)
class CreateVinculacionProyectos < ActiveRecord::Migration
  def change
    create_table :vinculacion_proyectos do |t|
      t.string :codigo, :limit => 20, :null => false
      t.string :descripcion
      t.text :obj_proyecto
      t.text :impacto
      t.text :resultado_esperado
      t.text :obj_estrategico
      t.string :duracion_meses, :limit => 2
      t.string :anio, :limit => 4
      t.string :status, :default => 0

      t.timestamps
    end
  end
end
