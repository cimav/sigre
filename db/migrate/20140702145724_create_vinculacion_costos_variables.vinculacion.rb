# This migration comes from vinculacion (originally 20140702145432)
class CreateVinculacionCostosVariables < ActiveRecord::Migration
  def change
    create_table :vinculacion_costos_variables do |t|
      t.references :servicio
      t.integer :tipo
      t.text :descripcion
      t.decimal :costo, :precision => 10, :scale => 2, :default => 0.00
      t.timestamps
    end
  end
end
