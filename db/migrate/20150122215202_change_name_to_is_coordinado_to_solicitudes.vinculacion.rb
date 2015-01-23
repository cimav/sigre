# This migration comes from vinculacion (originally 20150122215023)
class ChangeNameToIsCoordinadoToSolicitudes < ActiveRecord::Migration
  def change
    rename_column :vinculacion_solicitudes, :isCoordinado, :is_coordinado
  end
end
