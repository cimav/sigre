class CreateProyectosRecursos < ActiveRecord::Migration
  def change
    create_table :proyectos_recursos do |t|
      t.string :nombre
      t.text :descripcion
      t.references :tipo, index: true

      t.timestamps
    end
  end
end
