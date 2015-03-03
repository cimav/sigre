class AddTiempoEntregaToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :tiempo_entrega, :integer, :default => 1
  end
end
