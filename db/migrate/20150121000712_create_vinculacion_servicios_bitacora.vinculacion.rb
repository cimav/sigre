# This migration comes from vinculacion (originally 20150120234727)
class CreateVinculacionServiciosBitacora < ActiveRecord::Migration
  def change
    create_table :vinculacion_servicios_bitacora do |t|
      t.integer :bitacora_id
      t.string  :nombre
      t.string  :descripcion
      t.decimal :precio_venta, :precision => 10, :scale => 2, :default => 0.00
      t.integer :status, :default => 0
      t.timestamps
    end
  end
end