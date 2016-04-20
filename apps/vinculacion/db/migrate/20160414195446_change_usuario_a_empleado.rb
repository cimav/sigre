class ChangeUsuarioAEmpleado < ActiveRecord::Migration
  def change
    rename_column :vinculacion_registros, :usuario_id, :empleado_id
  end
end