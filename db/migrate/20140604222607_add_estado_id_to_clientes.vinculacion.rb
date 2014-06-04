# This migration comes from vinculacion (originally 20140604222520)
class AddEstadoIdToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :estado_id, :integer
  end
end
