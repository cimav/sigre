# This migration comes from vinculacion (originally 20140502002517)
class AddDescripcionAndRemoveUnusedFieldsToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :descripcion, :text
    remove_column :vinculacion_solicitudes, :contacto_email
    remove_column :vinculacion_solicitudes, :notas
    remove_column :vinculacion_solicitudes, :acuerdos
  end
end
