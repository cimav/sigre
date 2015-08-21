class AddVinculacionHashToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :vinculacion_hash, :string
  end
end
