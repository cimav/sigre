class AddReferenceFromServiciosBitacoraToServicios < ActiveRecord::Migration
  def change
    add_reference :vinculacion_servicios, :servicio_bitacora, references: :vinculacion_servicios_bitacora;
  end
end
