# This migration comes from vinculacion (originally 20140604225911)
class AddCiudadToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :ciudad, :string
  end
end
