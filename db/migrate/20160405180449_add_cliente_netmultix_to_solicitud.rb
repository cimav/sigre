class AddClienteNetmultixToSolicitud < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :cliente_netmultix_id, :integer
    add_column :vinculacion_solicitudes, :cliente_netmultix_clave, :string
  end
end
