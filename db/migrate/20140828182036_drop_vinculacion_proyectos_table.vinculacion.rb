# This migration comes from vinculacion (originally 20140828181716)
class DropVinculacionProyectosTable < ActiveRecord::Migration
  def change
    drop_table :vinculacion_proyectos
  end
end
