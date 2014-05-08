# This migration comes from vinculacion (originally 20140508173156)
class RemoveTipoToSolicitudes < ActiveRecord::Migration
  def change
    remove_column :vinculacion_solicitudes, :tipo
  end
end
