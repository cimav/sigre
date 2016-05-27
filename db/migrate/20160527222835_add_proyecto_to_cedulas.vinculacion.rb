# This migration comes from vinculacion (originally 20160527161407)
class AddProyectoToCedulas < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedulas, :proyecto_id, :integer
  end
end
