# This migration comes from vinculacion (originally 20150819010119)
class AddVinculacionHashToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :vinculacion_hash, :string
  end
end
