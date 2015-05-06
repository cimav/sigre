class ChangeCosteosNombreServicioToText < ActiveRecord::Migration
  def change
    change_column :vinculacion_costeos, :nombre_servicio, :text
  end
end
