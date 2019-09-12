class AddLeyendaToVinculacionCosteos < ActiveRecord::Migration
  def change
    add_column :vinculacion_costeos, :leyenda, :text
    add_column :vinculacion_costeos, :mostrar_leyenda, :boolean, :default => false
  end
end
