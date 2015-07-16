# This migration comes from vinculacion (originally 20150716151310)
class CreateVinculacionMuestrasDetalle < ActiveRecord::Migration
  def change
    create_table :vinculacion_muestras_detalle do |t|
      t.references :muestra
      t.integer    :consecutivo
      t.string     :cliente_identificacion
      t.text       :notas
      t.string     :status, :default => 1
    end
  end
end
