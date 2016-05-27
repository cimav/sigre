class AddProyectoToCedulas < ActiveRecord::Migration
  def change
    add_column :vinculacion_cedula, :proyecto_id, :integer
  end
end
