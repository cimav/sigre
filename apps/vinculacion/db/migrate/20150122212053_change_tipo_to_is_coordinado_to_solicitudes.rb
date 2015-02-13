class ChangeTipoToIsCoordinadoToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :isCoordinado, :boolean
  end
end
