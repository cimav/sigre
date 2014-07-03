class FixReferencesToCedulas < ActiveRecord::Migration
  def change
    remove_column :vinculacion_costos_variables, :servicio_id
    remove_column :vinculacion_remanentes, :servicio_id

    add_reference :vinculacion_costos_variables, :cedula
    add_reference :vinculacion_remanentes, :cedula
  end
end
