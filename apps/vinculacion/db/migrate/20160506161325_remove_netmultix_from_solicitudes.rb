class RemoveNetmultixFromSolicitudes < ActiveRecord::Migration
  def change
    remove_column :vinculacion_solicitudes, :cliente_netmultix_id
    remove_column :vinculacion_solicitudes, :contacto_netmultix_id
    remove_column :vinculacion_solicitudes, :contacto_netmultix_nombre
    remove_column :vinculacion_solicitudes, :contacto_netmultix_email
    remove_column :vinculacion_solicitudes, :pais_netmultix_nombre
    remove_column :vinculacion_solicitudes, :estado_netmultix_nombre
    remove_column :vinculacion_solicitudes, :ciudad_netmultix_nombre
  end
end
