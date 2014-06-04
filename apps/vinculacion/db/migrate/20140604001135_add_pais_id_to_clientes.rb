class AddPaisIdToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :pais_id, :integer
  end
end
