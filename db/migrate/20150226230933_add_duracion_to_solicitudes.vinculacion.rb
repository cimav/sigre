# This migration comes from vinculacion (originally 20150226230802)
class AddDuracionToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :duracion, :integer, :default => 1
  end
end
