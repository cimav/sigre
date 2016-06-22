# This migration comes from vinculacion (originally 20160620165956)
class AddObservacionesToCedulas < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedulas, :observaciones, :string
  end
end

