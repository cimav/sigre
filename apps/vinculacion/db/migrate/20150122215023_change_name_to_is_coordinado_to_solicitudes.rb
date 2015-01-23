class ChangeNameToIsCoordinadoToSolicitudes < ActiveRecord::Migration
  def change
    rename_column :vinculacion_solicitudes, :isCoordinado, :is_coordinado
  end
end
