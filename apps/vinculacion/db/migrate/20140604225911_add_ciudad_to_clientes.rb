class AddCiudadToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :ciudad, :string
  end
end
