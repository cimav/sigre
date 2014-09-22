# This migration comes from proyectos (originally 20140922185336)
class AddProyectoBaseToProyectos < ActiveRecord::Migration
  def change
    add_reference :proyectos_proyectos, :proyecto_base, references: :proyectos;
  end
end
