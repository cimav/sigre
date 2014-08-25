class CreateProyectosFondos < ActiveRecord::Migration
  def change
    create_table :proyectos_fondos do |t|
      t.string :nombre
      t.text :descripcion

      t.timestamps
    end
  end
end
