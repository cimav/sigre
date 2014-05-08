class AddTamanoEmpresaAndSectorToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :tamano_empresa, :integer
    add_column :vinculacion_clientes, :sector, :integer
  end
end
