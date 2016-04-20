class AddBitacoraIdToRegistro < ActiveRecord::Migration
  def change
  	add_column :vinculacion_registros, :bitacora_alerta_id, :integer, :default => 0
  	add_column :vinculacion_registros, :empleado_cierre_id, :integer, :default => 0
  	add_column :vinculacion_registros, :fecha_apertura, :date
    add_column :vinculacion_registros, :fecha_cierre, :date
  end
end
