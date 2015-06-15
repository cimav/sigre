# This migration comes from vinculacion (originally 20150615220546)
class AddTiempoEstimadoToServicios < ActiveRecord::Migration
  def change
    add_column :vinculacion_servicios, :tiempo_estimado, :integer, :default => 0
  end
end
