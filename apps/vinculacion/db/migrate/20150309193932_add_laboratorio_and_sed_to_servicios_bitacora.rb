class AddLaboratorioAndSedToServiciosBitacora < ActiveRecord::Migration
  def change
    add_column :vinculacion_servicios_bitacora, :sede_id, :integer
    add_column :vinculacion_servicios_bitacora, :laboratorio_bitacora_id, :integer
  end
end
