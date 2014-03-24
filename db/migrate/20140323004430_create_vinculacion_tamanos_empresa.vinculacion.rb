# This migration comes from vinculacion (originally 20140319234245)
class CreateVinculacionTamanosEmpresa < ActiveRecord::Migration
  def change
    create_table :vinculacion_tamanos_empresa do |t|
      t.string     :codigo, :limit => 20
      t.text       :descripcion
      t.timestamps
    end
  end
end
