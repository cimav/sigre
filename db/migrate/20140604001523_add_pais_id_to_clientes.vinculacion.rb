# This migration comes from vinculacion (originally 20140604001135)
class AddPaisIdToClientes < ActiveRecord::Migration
  def change
    add_column :vinculacion_clientes, :pais_id, :integer
  end
end
