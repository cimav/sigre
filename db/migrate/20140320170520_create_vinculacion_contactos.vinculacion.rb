# This migration comes from vinculacion (originally 20140320164832)
class CreateVinculacionContactos < ActiveRecord::Migration
  def change
    create_table :vinculacion_contactos do |t|
      t.string :nombre
      t.string :telefono
      t.string :email
      t.string :departamento
      t.string :puesto
      t.string :notas
      t.references :cliente

      t.timestamps
    end
  end
end
