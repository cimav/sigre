class CreateVinculacionRegistros < ActiveRecord::Migration
  def change
    create_table :vinculacion_registros do |t|
      t.references :usuario
      t.references :solicitud
      t.string     :tipo
      t.text       :mensaje
      t.timestamps
    end
    add_index('vinculacion_registros', 'usuario_id')
    add_index('vinculacion_registros', 'solicitud_id')
  end
end