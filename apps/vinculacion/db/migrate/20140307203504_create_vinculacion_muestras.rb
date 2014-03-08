class CreateVinculacionMuestras < ActiveRecord::Migration
  def change
    create_table :vinculacion_muestras do |t|
      t.references :solicitud
      t.integer    :consecutivo
      t.string     :codigo, :limit => 20
      t.string     :identificacion
      t.text       :descripcion
      t.integer    :cantidad
      t.references :usuario
      t.string :status, :default => 1 
      t.timestamps
    end
  end
end
