# This migration comes from vinculacion (originally 20140508182104)
class AddTamanoEmpresaAndSectorToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :tamano_empresa, :integer
    add_column :vinculacion_clientes, :sector, :integer
  end
end
