class DropVinculacionProyectosTable < ActiveRecord::Migration
  def change
    drop_table :vinculacion_proyectos
  end
end
