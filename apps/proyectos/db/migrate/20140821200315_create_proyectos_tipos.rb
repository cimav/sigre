class CreateProyectosTipos < ActiveRecord::Migration
  def change
    create_table :proyectos_tipos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
