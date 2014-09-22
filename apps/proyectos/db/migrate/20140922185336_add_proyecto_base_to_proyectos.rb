class AddProyectoBaseToProyectos < ActiveRecord::Migration
  def change
    add_reference :proyectos_proyectos, :proyecto_base, references: :proyectos;
  end
end
