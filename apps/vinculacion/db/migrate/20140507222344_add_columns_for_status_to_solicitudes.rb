class AddColumnsForStatusToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :motivo_status, :text
    add_column :vinculacion_solicitudes, :razon_cancelacion, :string, :default => 1
  end
end
