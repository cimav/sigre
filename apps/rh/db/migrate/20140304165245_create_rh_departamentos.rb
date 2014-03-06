class CreateRhDepartamentos < ActiveRecord::Migration
  def change
    create_table :rh_departamentos do |t|
      t.string     :nombre,             :null => false
      t.string     :descripcion,        :null => false
      t.references :sede
      t.references :empleado
      t.references :departamento
      t.string     :image
      t.timestamps
    end
  end
end
