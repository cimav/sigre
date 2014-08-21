# This migration comes from proyectos (originally 20140821200315)
class CreateProyectosTipos < ActiveRecord::Migration
  def change
    create_table :proyectos_tipos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
