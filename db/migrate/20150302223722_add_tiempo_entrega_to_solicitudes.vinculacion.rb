# This migration comes from vinculacion (originally 20150302223332)
class AddTiempoEntregaToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :tiempo_entrega, :integer, :default => 1
  end
end
