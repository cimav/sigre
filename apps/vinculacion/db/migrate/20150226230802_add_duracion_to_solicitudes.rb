class AddDuracionToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :duracion, :integer, :default => 0
  end
end
