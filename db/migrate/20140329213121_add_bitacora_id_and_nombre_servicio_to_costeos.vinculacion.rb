# This migration comes from vinculacion (originally 20140329213004)
class AddBitacoraIdAndNombreServicioToCosteos < ActiveRecord::Migration
  def change
    add_column :vinculacion_costeos, :bitacora_id, :integer
    add_column :vinculacion_costeos, :nombre_servicio, :string
  end
end
