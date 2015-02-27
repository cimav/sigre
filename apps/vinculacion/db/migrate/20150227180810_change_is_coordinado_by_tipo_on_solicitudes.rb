class ChangeIsCoordinadoByTipoOnSolicitudes < ActiveRecord::Migration
  def change
    remove_column :vinculacion_solicitudes, :is_coordinado
    add_column :vinculacion_solicitudes, :tipo, :integer, default: 1
  end
end
