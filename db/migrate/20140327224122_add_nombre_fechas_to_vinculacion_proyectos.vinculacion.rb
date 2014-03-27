# This migration comes from vinculacion (originally 20140327222851)
class AddNombreFechasToVinculacionProyectos < ActiveRecord::Migration
  def change
    add_column :vinculacion_proyectos, :nombre, :string
    add_column :vinculacion_proyectos, :fecha_inicio, :date
    add_column :vinculacion_proyectos, :fecha_termino, :date
    remove_column :vinculacion_proyectos, :duracion_meses
  end
end
