# This migration comes from vinculacion (originally 20150122212053)
class ChangeTipoToIsCoordinadoToSolicitudes < ActiveRecord::Migration
  def change
    remove_column :vinculacion_solicitudes, :tipo
    add_column :vinculacion_solicitudes, :isCoordinado, :boolean
  end
end
