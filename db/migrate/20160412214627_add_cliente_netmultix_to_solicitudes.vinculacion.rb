# This migration comes from vinculacion (originally 20160412214534)
class AddClienteNetmultixToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :cliente_netmultix_id, :integer
    add_column :vinculacion_solicitudes, :contacto_netmultix_id, :integer
    add_column :vinculacion_solicitudes, :contacto_netmultix_nombre, :string
    add_column :vinculacion_solicitudes, :contacto_netmultix_email, :string
  end
end
