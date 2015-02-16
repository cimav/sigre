class AddClaveNombreToVinculacionClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :clave, :string
    add_column :vinculacion_clientes, :nombre, :string
  end
end
