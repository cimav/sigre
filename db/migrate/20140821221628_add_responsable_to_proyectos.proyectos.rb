# This migration comes from proyectos (originally 20140821221456)
class AddResponsableToProyectos < ActiveRecord::Migration
  def change
    add_reference :proyectos_proyectos, :responsable, references: :empleados;
  end
end

