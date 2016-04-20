# This migration comes from vinculacion (originally 20160406214546)
class CreateVinculacionRegistrosNota < ActiveRecord::Migration
  def change
    create_table :vinculacion_registros_nota do |t|
      t.references :usuario
      t.references :registro
      t.text       :mensaje
      t.timestamps null: false
    end
  end
end
