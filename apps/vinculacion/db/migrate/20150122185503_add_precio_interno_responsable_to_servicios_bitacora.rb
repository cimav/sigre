class AddPrecioInternoResponsableToServiciosBitacora < ActiveRecord::Migration
  def change
    add_column :vinculacion_servicios_bitacora, :precio_interno, :decimal, :precision => 10, :scale => 2, :default => 0.00
    add_reference :vinculacion_servicios_bitacora, :empleado, references: :rh_empleados
  end
end


