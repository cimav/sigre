class CreateVinculacionArchivos < ActiveRecord::Migration
  def change
    create_table :vinculacion_archivos do |t|
      t.references :usuario
      t.references :solicitud
      t.integer    :tipo_archivo
      t.string     :descripcion
      t.string     :archivo
      t.integer    :status
      t.timestamps null: false
    end
  end
end
