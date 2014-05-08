class RemoveTipoToSolicitudes < ActiveRecord::Migration
  def change
    remove_column :vinculacion_solicitudes, :tipo
  end
end
