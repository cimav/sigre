class AddClienteNetmultixToSolicitudes < ActiveRecord::Migration
  def change
    add_column :vinculacion_solicitudes, :cliente_netmultix_id, :integer
    add_column :vinculacion_solicitudes, :contacto_netmultix_id, :integer
    add_column :vinculacion_solicitudes, :contacto_netmultix_nombre, :string
    add_column :vinculacion_solicitudes, :contacto_netmultix_email, :string
    add_column :vinculacion_solicitudes, :pais_netmultix_nombre, :string
    add_column :vinculacion_solicitudes, :estado_netmultix_nombre, :string
    add_column :vinculacion_solicitudes, :ciudad_netmultix_nombre, :string
  end
end
