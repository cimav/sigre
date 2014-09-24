# This migration comes from proyectos (originally 20140903223013)
class AddRecursoToProyectosFondos < ActiveRecord::Migration
  def change
    add_reference :proyectos_fondos, :recurso
  end
end
