# This migration comes from vinculacion (originally 20160414195446)
class ChangeUsuarioAEmpleado < ActiveRecord::Migration
  def change
    rename_column :vinculacion_registros, :usuario_id, :empleado_id
  end
end