# This migration comes from vinculacion (originally 20150409161242)
class ChangesCantidadToDecimalInCosteosDetalle < ActiveRecord::Migration
  def change
    change_column :vinculacion_costeos_detalle, :cantidad, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end
end
