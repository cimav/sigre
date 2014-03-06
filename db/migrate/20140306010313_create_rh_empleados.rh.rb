# This migration comes from rh (originally 20140304164720)
class CreateRhEmpleados < ActiveRecord::Migration
  def change
    create_table :rh_empleados do |t|
      t.string     :nombre,             :null => false
      t.string     :apellido_paterno,   :null => false
      t.string     :apellido_materno,   :null => false
      t.string     :email,              :null => false
      t.string     :codigo
      t.string     :puesto
      t.references :sede
      t.date       :fecha_nacimiento
      t.references :pais
      t.date       :fecha_inicio
      t.date       :fecha_fin
      t.string     :curp
      t.string     :rfc
      t.references :departamento
      t.references :empleado
      t.string     :image
      t.timestamps
    end
  end
end
