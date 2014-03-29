class MoveMuestraIdFromCosteoDetalleToCosteos < ActiveRecord::Migration
  def change
    remove_column :vinculacion_costeos_detalle, :muestra_id
    add_column :vinculacion_costeos, :muestra_id, :integer
  end
end
