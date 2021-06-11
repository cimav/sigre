class AddContactoNetmultixIdToCedulaVinculacion < ActiveRecord::Migration
  def change

    add_column :vinculacion_cedulas, :contacto_netmultix_id, :integer

  end
end
