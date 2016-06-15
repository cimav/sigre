# This migration comes from vinculacion (originally 20160615204206)
class AddUsuarioFechaTransmisionToCedulas < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedulas, :usuario_id, :integer
    add_column :vinculacion_cedulas, :transmitida_at, :datetime
  end
end
