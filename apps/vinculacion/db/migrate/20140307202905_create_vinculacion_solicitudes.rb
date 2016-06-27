class CreateVinculacionSolicitudes < ActiveRecord::Migration
  def change
    create_table :vinculacion_solicitudes do |t|
      t.integer    :consecutivo
      t.string     :codigo, :limit => 20
      t.integer    :tipo
      t.references :proyecto
      t.references :sede
      t.integer    :prioridad
      t.references :cliente
      t.references :contacto
      t.string     :contacto_email
      t.text       :notas
      t.text       :acuerdos
      t.references :usuario
      t.string :status, :default => 1
      t.timestamps
    end
  end
end
