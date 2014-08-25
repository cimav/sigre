class AddResponsableToProyectos < ActiveRecord::Migration
  def change
    add_reference :proyectos_proyectos, :responsable, references: :empleados;
  end
end

