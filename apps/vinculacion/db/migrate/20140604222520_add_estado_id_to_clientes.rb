class AddEstadoIdToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :estado_id, :integer
  end
end
