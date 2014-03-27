# This migration comes from vinculacion (originally 20140318210033)
class CreateVinculacionServicios < ActiveRecord::Migration
  def change
    create_table :vinculacion_servicios do |t|
      t.references :solicitud
      t.integer    :consecutivo
      t.string     :codigo, :limit => 20
      t.string     :nombre
      t.text       :descripcion
      t.references :empleado
      t.string     :status, :default => 1
      t.timestamps
    end
  end
end
