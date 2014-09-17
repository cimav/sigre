class AddRecursoToProyectosFondos < ActiveRecord::Migration
  def change
    add_reference :proyectos_fondos, :recurso
  end
end
