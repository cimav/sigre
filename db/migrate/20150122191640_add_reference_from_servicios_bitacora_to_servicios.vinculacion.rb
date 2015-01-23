# This migration comes from vinculacion (originally 20150122191441)
class AddReferenceFromServiciosBitacoraToServicios < ActiveRecord::Migration
  def change
    add_reference :vinculacion_servicios, :servicio_bitacora, references: :vinculacion_servicios_bitacora;
  end
end
