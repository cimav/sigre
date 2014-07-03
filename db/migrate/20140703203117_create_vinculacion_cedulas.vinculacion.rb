# This migration comes from vinculacion (originally 20140703202039)
class CreateVinculacionCedulas < ActiveRecord::Migration
  def change
    create_table :vinculacion_cedulas do |t|
      t.references :solicitud
      t.references :servicio
      t.text :codigo
      t.integer :status, :default => 1
      t.timestamps
    end
  end
end
